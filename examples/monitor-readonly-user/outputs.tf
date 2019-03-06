output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${module.account_setup.mfa_policy_arn}"
}

output "trail_arn" {
  description = "Cloud trail arn."
  value       = "${module.account_setup.trail_arn}"
}

output "monitor_readonly_user_arn" {
  description = "ARN for the monitor readonly user"
  value       = "${module.account_setup.monitor_readonly_user_arn}"
}

output "monitor_readonly_user_access_key_id" {
  description = "Access key id for the monitor readonly user"
  value       = "${module.account_setup.monitor_readonly_user_access_key_id}"
}

output "monitor_readonly_user_secret_access_key" {
  description = "Secret access key for the monitor readonly user"
  value       = "${module.account_setup.monitor_readonly_user_secret_access_key}"
}
