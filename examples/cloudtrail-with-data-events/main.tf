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

  # Configure Data events below example 
  event_selector = [{
    read_write_type           = "All"
    include_management_events = true

    data_resource = [
      {
        type   = "AWS::Lambda::Function"
        values = ["arn:aws:lambda"]
      },
    ]
    },
    {
      read_write_type           = "WriteOnly"
      include_management_events = true

      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    },
  ]
}
