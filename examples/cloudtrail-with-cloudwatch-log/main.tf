provider "aws" {
  region  = "eu-west-1"
  version = "1.24.0"
}

provider "template" {
  version = "1.0"
}

module "account_setup" {
  source = "../../"

  enable_cloudtrail = true
  enable_cloudwatch_logs = true
  trail_name        = "my-account-trail"
}
