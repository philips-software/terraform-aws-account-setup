provider "aws" {
  region  = "eu-west-1"
  version = "~> 1.31"
}

provider "template" {
  version = "1.0"
}

module "account_setup" {
  source = "../../"

  enable_aws_config              = true
  enable_account_password_policy = false
  enable_admin_group             = false
  enable_mfa                     = false
  aws_config_notification_emails = ["test@example.com"]

  # tag1Key = "Project"
}
