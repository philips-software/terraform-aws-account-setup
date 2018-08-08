output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${element(concat(aws_iam_policy.mfa.*.arn, list("")), 0)}"
}

output "trail_arn" {
  description = "Cloud trail arn."
  value       = "${element(concat(aws_cloudtrail.cloudtrail.*.arn, list("")), 0)}"
}
