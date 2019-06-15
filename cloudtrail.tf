data "aws_caller_identity" "current" {}

locals {
  bucket_name = "${data.aws_caller_identity.current.account_id}-${var.trail_name}-cloudtrail"
}

#
# CloudTrail
#
resource "aws_cloudtrail" "cloudtrail" {
  count = "${var.enable_cloudtrail ? 1 : 0}"

  name                          = "${var.trail_name}"
  s3_bucket_name                = "${var.cloudtrail_bucket != "" ? var.cloudtrail_bucket : local.bucket_name}"
  cloud_watch_logs_role_arn     = "${join("", aws_iam_role.cloudwatch_iam_role.*.arn)}"
  cloud_watch_logs_group_arn    = "${join("", aws_cloudwatch_log_group.log_group.*.arn)}"
  include_global_service_events = "${var.include_global_service_events}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  is_multi_region_trail         = "${var.is_multi_region_trail}"
  event_selector                = "${var.event_selector}"
  kms_key_id                    = "${var.kms_key_id}"

  tags = "${var.tags}"
}

#
# CloudTrail Cloudwatch Log Group
#
resource "aws_cloudwatch_log_group" "log_group" {
  count = "${var.enable_cloudwatch_logs}"
  name = "${var.cloudwatch_log_group_name}"
}

#
# CloudTrail Cloudwatch IAM Role
#
data "template_file" "cloudwatch_iam_assume_role_policy_document" {
  template = "${file("${path.module}/policies/cloudwatch_assume_role_policy.tpl")}"
}

resource "aws_iam_role" "cloudwatch_iam_role" {
  count              = "${var.enable_cloudwatch_logs}"
  name               = "${var.cloudwatch_iam_role_name}"
  assume_role_policy = "${data.template_file.cloudwatch_iam_assume_role_policy_document.rendered}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_iam_policy_attachment" {
  count      = "${var.enable_cloudwatch_logs}"
  role       = "${aws_iam_role.cloudwatch_iam_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_iam_policy.arn}"
}

data "template_file" "cloudwatch_iam_policy_document" {
  count    = "${var.enable_cloudwatch_logs}"
  template = "${file("${path.module}/policies/cloudwatch_policy.tpl")}"

  vars {
    log_group_arn = "${aws_cloudwatch_log_group.log_group.arn}"
  }
}

resource "aws_iam_policy" "cloudwatch_iam_policy" {
  count  = "${var.enable_cloudwatch_logs}"
  name   = "${var.cloudwatch_iam_policy_name}"
  policy = "${data.template_file.cloudwatch_iam_policy_document.rendered}"
}

#
# CloudTrail S3 bucket
#
resource "aws_kms_key" "cloudtrail_bucket_key" {
  count = "${var.enable_cloudtrail ? 1 : 0}"

  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  count = "${var.enable_cloudtrail && var.cloudtrail_bucket == "" ? 1 : 0}"

  bucket        = "${local.bucket_name}"
  force_destroy = true
  region        = "${var.cloudtrail_bucket_region}"

  tags = "${var.tags}"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cloudtrail_bucket_key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.bucket_name}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
