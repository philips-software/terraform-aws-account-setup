output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${element(concat(aws_iam_policy.mfa.*.arn, list("")), 0)}"
}
