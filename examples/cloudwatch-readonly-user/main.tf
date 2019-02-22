provider "aws" {
  region  = "eu-west-1"
  version = "1.24.0"
}

provider "template" {
  version = "1.0"
}

module "account_setup" {
  source = "../../"

  enable_cloudwatch_readonly_user = true
  cloudwatch_readonly_user_name   = "example-cloudwatch-readonly"
}
