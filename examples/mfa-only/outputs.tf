output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${module.account_setup.mfa_policy_arn}"
}
