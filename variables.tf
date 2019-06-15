variable "enable_mfa" {
  description = "Enable to force MFA usages."
  default     = true
}

variable "enable_admin_group" {
  description = "Create an admin group."
  default     = true
}

variable "enable_account_password_policy" {
  description = "Enable custom (strict) password policy."
  default     = true
}

variable "admin_group_name" {
  description = "Name of the admin group."
  default     = "admins"
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing."
  default     = true
}

variable "minimum_password_length" {
  description = "Minimum length to require for user passwords."
  default     = 32
}

variable "require_lowercase_characters" {
  description = "Whether to require lowercase characters for user passwords."
  default     = true
}

variable "require_numbers" {
  description = "Whether to require numbers for user passwords."
  default     = true
}

variable "require_uppercase_characters" {
  description = "Whether to require uppercase characters for user passwords."
  default     = true
}

variable "require_symbols" {
  description = "Whether to require symbols for user passwords."
  default     = true
}

variable "allow_users_to_change_password" {
  description = "Whether to allow users to change their own password"
  default     = true
}

variable "max_password_age" {
  description = "The number of days that an user password is valid."
  default     = 33
}

variable "hard_expiry" {
  description = "Whether users are prevented from setting a new password after their password has expired (i.e. require administrator reset)"
  default     = false
}

variable "enable_read_only_group" {
  description = "Creates a group with read-only IAM policy assigned to it."
  default     = false
}

variable "read_only_group_name" {
  description = "Name for read-only group."
  default     = "read-only"
}

### CLOUDTRAIL

variable "cloudtrail_bucket_region" {
  type        = "string"
  description = "The region where the cloudtrail bucket will be created or is located, required if cloudtrail is enabled"
  default     = ""
}

variable "cloudtrail_bucket" {
  type        = "string"
  description = "The name of the cloudtrail bucket"
  default     = ""
}

variable "tags" {
  type        = "map"
  description = "Map of tags to apply on the resources"
  default     = {}
}

variable "trail_name" {
  description = "Name of the cloud trail. Required if the cloudtrail is enabled."
  default     = ""
}

variable "include_global_service_events" {
  description = "Specifies whether the trail is publishing events from global services such as IAM to the log files. "
  default     = true
}

variable "enable_log_file_validation" {
  description = "Specifies whether log file integrity validation is enabled."
  default     = true
}

variable "is_multi_region_trail" {
  description = "Specifies whether the trail is created in the current region or in all regions. "
  default     = true
}

variable "event_selector" {
  type        = "list"
  description = "Specifies an event selector for enabling data event logging, It needs to be a list of map values. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this map variable"
  default     = []
}

variable "enable_cloudtrail" {
  description = "Create a default cloudtrail for the account."
  default     = false
}

variable "enable_cloudwatch_logs" {
  description = "Enable Cloudwatch Logs for Cloudtrail."
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "The name of the cloudwatch log name"
  default     = "CloudTrail/DefaultLogGroup"
}

variable "cloudwatch_iam_policy_name" {
  description = "The name of the policy which is used for the cloudtrail cloudwatch role"
  default = "terraform-cloudwatch-policy"
}

variable "cloudwatch_iam_role_name" {
  description = "The name of the role which of the cloudtrail cloudwatch role"
  default = "terraform-cloudwatch-role"
}

variable "enable_monitor_readonly_user" {
  description = "Create a user that can read monitor metrics (e.g. for grafana)"
  default     = false
}

variable "monitor_readonly_user_name" {
  description = "The user name for the monitor read only user"
  default     = "monitor_readonly"
}

variable "kms_key_id" {
  description = "The arn of the CMK key which is used for encrypting cloudtrail logs"
  default     = ""
}

### AWS Config
variable "aws_config_notification_emails" {
  description = "A list of email addresses for that will receive AWS Config changes notifications"
  default     = []
  type        = "list"
}

variable "enable_aws_config" {
  description = "Specifies if the AWS Config should be enabled"
  default     = false
}

variable "tag1Key" {
  description = "Specifies value of the Key for Tag1"
  default     = ""
}

variable "enable_rule_require_tag" {
  description = "Specifies if 'Require Tag' rule should be enabled"
  default     = false
}

variable "enable_rule_require_root_account_MFA" {
  description = "Specifies if 'Require root account MFA enabled' rule should be enabled"
  default     = false
}

variable "enable_rule_require_cloud_trail" {
  description = "Specifies if 'Cloud Trail enabled' rule should be enabled"
  default     = false
}

variable "enable_rule_iam_password_policy" {
  description = "Specifies if 'IAM password policy' rule should be enabled"
  default     = false
}

### SSM Session Manager
variable "enable_ssm_session_manager" {
  description = "Specifies if the ssm session manager should be enabled"
  default     = false
}

variable "s3_bucket_name" {
  default     = ""
  description = "(Optional) The name of bucket to store session logs. Specifying this enables writing session output to an Amazon S3 bucket."
}

variable "s3_key_prefix" {
  default = ""
  description = "(Optional) To write output to a sub-folder, enter a sub-folder name."
}

variable "s3_encryption_enabled" {
  default = false
  description = "(Optional) Encrypt log data."
}

variable "cloudwatch_log_group_name" {
  default = ""
  description = "(Optional) The name of the log group to upload session logs to. Specifying this enables sending session output to CloudWatch Logs."
}

variable "cloudwatch_encryption_enabled" {
  default = false
  description = "(Optional) Encrypt log data."
}
