provider "aws" {
  region  = "eu-west-1"
  version = "2.7.0"
}

provider "template" {
  version = "2.1.0"
}

module "account_setup" {
  source = "../../"

  enable_monitor_readonly_user = true
  monitor_readonly_user_name   = "example-monitor-readonly"
}
