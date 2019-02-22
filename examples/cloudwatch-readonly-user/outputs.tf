output "mfa_policy_arn" {
  description = "MFA Policy arn."
  value       = "${module.account_setup.mfa_policy_arn}"
}

output "trail_arn" {
  description = "Cloud trail arn."
  value       = "${module.account_setup.trail_arn}"
}

output "cloudwatch_readonly_user_access_key_id" {
  description = "Access key id for the Cloudwatch readonly user"
  value       = "${module.account_setup.cloudwatch_readonly_user_access_key_id}"
}

output "cloudwatch_readonly_user_secret_access_key" {
  description = "Secret access key for the Cloudwatch readonly user"
  value       = "${module.account_setup.cloudwatch_readonly_user_secret_access_key}"
}
