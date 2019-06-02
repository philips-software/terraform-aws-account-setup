output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${module.account_setup.mfa_policy_arn}"
}

output "trail_arn" {
  description = "Cloud trail arn."
  value       = "${module.account_setup.trail_arn}"
}
