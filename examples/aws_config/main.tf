provider "aws" {
  region  = "eu-west-1"
  version = "2.7.0"
}

provider "template" {
  version = "2.1.0"
}

module "account_setup" {
  source = "../../"

  enable_aws_config                    = true
  enable_account_password_policy       = false
  enable_admin_group                   = false
  enable_mfa                           = false
  aws_config_notification_emails       = ["test@example.com"]
  tag1Key                              = "Project"
  enable_rule_require_tag              = true
  enable_rule_require_root_account_MFA = true
  enable_rule_require_cloud_trail      = true
  enable_rule_iam_password_policy      = true
}
