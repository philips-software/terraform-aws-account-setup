output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${element(concat(aws_iam_policy.mfa.*.arn, list("")), 0)}"
}

output "trail_arn" {
  description = "Cloud trail arn."
  value       = "${element(concat(aws_cloudtrail.cloudtrail.*.arn, list("")), 0)}"
}

output "cloudwatch_log_group_arn" {
  description = "Cloud trail arn."
  value       = "${element(concat(aws_cloudwatch_log_group.log_group.*.arn, list("")), 0)}"
}
