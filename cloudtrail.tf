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
  include_global_service_events = "${var.include_global_service_events}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  is_multi_region_trail         = "${var.is_multi_region_trail}"
  event_selector                = "${var.event_selector}"
  kms_key_id                    = "${var.kms_key_id}"

  tags = "${var.tags}"
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
