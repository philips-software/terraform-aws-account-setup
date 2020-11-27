provider "aws" {
  region  = "eu-west-1"
  version = "2.7.0"
}

provider "template" {
  version = "2.1.0"
}

module "account_setup" {
  source = "../../"

  # Cloudtrail (optional)
  enable_cloudtrail        = true
  trail_name               = "my-account-trail"
}
