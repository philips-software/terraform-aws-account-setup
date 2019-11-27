provider "aws" {
  region  = "eu-west-1"
  version = "2.13.0"
}

provider "template" {
  version = "2.1.2"
}

module "account_setup" {
  source = "../../"

  enable_cloudtrail      = true
  enable_cloudwatch_logs = true
  admin_group_name       = "admin-test"

  cloudwatch_log_group_name  = "myCloudwatchLogGroup"
  cloudwatch_iam_policy_name = "myCloudwatchPolicyName"
  cloudwatch_iam_role_name   = "myCloudwatchRoleName"

  trail_name = "my-account-trail"
}
