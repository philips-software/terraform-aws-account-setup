output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${element(concat(aws_iam_policy.mfa.*.arn, list("")), 0)}"
}

output "trail_arn" {
  description = "Cloud trail arn."
  value       = "${element(concat(aws_cloudtrail.cloudtrail.*.arn, list("")), 0)}"
}

output "cloudwatch_readonly_user_access_key_id" {
  description = "Access key id for the Cloudwatch readonly user"
  value       = "${element(concat(aws_iam_access_key.cloudwatch_readonly_user_access_key.*.id, list("")), 0)}"
}

output "cloudwatch_readonly_user_secret_access_key" {
  description = "Secret access key for the Cloudwatch readonly user"
  value       = "${element(concat(aws_iam_access_key.cloudwatch_readonly_user_access_key.*.secret, list("")), 0)}"
}
