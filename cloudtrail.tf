data "aws_caller_identity" "current" {
}

locals {
  bucket_name = "${data.aws_caller_identity.current.account_id}-${var.trail_name}-cloudtrail"
}

#
# CloudTrail
#
resource "aws_cloudtrail" "cloudtrail" {
  count = var.enable_cloudtrail ? 1 : 0

  name                          = var.trail_name
  s3_bucket_name                = var.cloudtrail_bucket != "" ? var.cloudtrail_bucket : local.bucket_name
  cloud_watch_logs_role_arn     = join("", aws_iam_role.cloudwatch_iam_role.*.arn)
  cloud_watch_logs_group_arn    = join("", aws_cloudwatch_log_group.log_group.*.arn, ":*")
  include_global_service_events = var.include_global_service_events
  enable_log_file_validation    = var.enable_log_file_validation
  is_multi_region_trail         = var.is_multi_region_trail
  dynamic "event_selector" {
    for_each = var.event_selector
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

      include_management_events = lookup(event_selector.value, "include_management_events", null)
      read_write_type           = lookup(event_selector.value, "read_write_type", null)

      dynamic "data_resource" {
        for_each = lookup(event_selector.value, "data_resource", [])
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }
  kms_key_id = var.kms_key_id

  tags = var.tags
}

#
# CloudTrail Cloudwatch Log Group
#
resource "aws_cloudwatch_log_group" "log_group" {
  count = var.enable_cloudwatch_logs ? 1 : 0
  name  = var.cloudwatch_log_group_name
}

#
# CloudTrail Cloudwatch IAM Role
#
data "aws_iam_policy_document" "cloudwatch_assume" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrial.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch_iam_role" {
  count              = var.enable_cloudwatch_logs ? 1 : 0
  name               = var.cloudwatch_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_iam_policy_attachment" {
  count      = var.enable_cloudwatch_logs ? 1 : 0
  role       = aws_iam_role.cloudwatch_iam_role[0].name
  policy_arn = aws_iam_policy.cloudwatch_iam_policy[0].arn
}

data "aws_iam_policy_document" "cloudwatch" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${one(aws_cloudwatch_log_group.log_group).arn}:*"]
  }
}

resource "aws_iam_policy" "cloudwatch_iam_policy" {
  count  = var.enable_cloudwatch_logs ? 1 : 0
  name   = var.cloudwatch_iam_policy_name
  policy = one(data.aws_iam_policy_document.cloudwatch).rendered
}

#
# CloudTrail S3 bucket
#
resource "aws_kms_key" "cloudtrail_bucket_key" {
  count = var.enable_cloudtrail ? 1 : 0

  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  count = var.enable_cloudtrail && var.cloudtrail_bucket == "" ? 1 : 0

  bucket        = local.bucket_name
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket" {
  count  = var.enable_cloudtrail && var.cloudtrail_bucket == "" ? 1 : 0
  bucket = one(aws_s3_bucket.cloudtrail_bucket).bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cloudtrail_bucket_key[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_bucket" {
  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.bucket_name}"]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket_name}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket" {
  count  = var.enable_cloudtrail && var.cloudtrail_bucket == "" ? 1 : 0
  bucket = one(aws_s3_bucket.cloudtrail_bucket).bucket
  policy = data.aws_iam_policy_document.cloudtrail_bucket.json
}

