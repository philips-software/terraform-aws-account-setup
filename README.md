# Terraform module configure IAM in a new Amazon account_setup

This terraform modules configures the following in IAM:

- Creates a policy to enforce MFA
- Sets a script password policy
- Creates a group with admin privileges, with MFA enable_admin_group
- Creates a group with read-only policy (disabled by default)
- Creates a global cloud trail (disabled by default)
- Creates a user including access keys for monitoring purposes (disabled by default)

All features can be enabled or disabled, default is enabled.

The following AWS Config rules can be enabled (AWS Config is disabled by default, each rule can be enabled individually):

- Require a specific tag on the resources<sup>1</sup>
- Require root account MFA enabled
- Cloud trail enabled
- IAM password policy compliance

<sup>1</sup>Terraform does not allow passing unset value similar to `!Ref "AWS::NoValue"`. Due to this limitation only a single tag `tag1Key` can be passed as a parameter to to this module. If you require additional key-value pairs in your AWS config REQUIRED_TAGS rule, the module must be extended manually.

## Terraform version

- Terraform 0.12: Pin module to `~> 2+`, submit pull request to branch `develop`
- Terraform 0.11: Pin module to `~> 1.x`, submit pull request to branch `terraform011`

## Usage

### Example usages

```terraform
module "account_setup" {
  source = "philips-software/account-setup/aws"
  version = "2.0.0"

  # Or via github
  # source = "github.com/philips-software/terraform-aws-account-setup?ref=2.0.0"

  # Cloudtrail (optional)
  enable_cloudtrail        = true
  cloudtrail_bucket_region = "eu-west-1"
  trail_name               = "my-account-trail"

  # Creates read only group (optional)
  enable_read_only_group = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_group_name | Name of the admin group. | string | `admins` | no |
| allow_users_to_change_password | Whether to allow users to change their own password | string | `true` | no |
| aws_config_notification_emails | A list of email addresses for that will receive AWS Config changes notifications | list | `<list>` | no |
| cloudtrail_bucket | The name of the cloudtrail bucket | string | `` | no |
| cloudtrail_bucket_region | The region where the cloudtrail bucket will be created or is located, required if cloudtrail is enabled | string | `` | no |
| enable_account_password_policy | Enable custom (strict) password policy. | string | `true` | no |
| enable_admin_group | Create an admin group. | string | `true` | no |
| enable_aws_config | Specifies if the AWS Config should be enabled | string | `false` | no |
| enable_cloudtrail | Create a default cloudtrail for the account. | string | `false` | no |
| enable_log_file_validation | Specifies whether log file integrity validation is enabled. | string | `true` | no |
| enable_mfa | Enable to force MFA usages. | string | `true` | no |
| enable_monitor_readonly_user | Create a user that can read monitor metrics (e.g. for grafana) | string | `false` | no |
| enable_read_only_group | Creates a group with read-only IAM policy assigned to it. | string | `false` | no |
| enable_rule_iam_password_policy | Specifies if 'IAM password policy' rule should be enabled | string | `false` | no |
| enable_rule_require_cloud_trail | Specifies if 'Cloud Trail enabled' rule should be enabled | string | `false` | no |
| enable_rule_require_root_account_MFA | Specifies if 'Require root account MFA enabled' rule should be enabled | string | `false` | no |
| enable_rule_require_tag | Specifies if 'Require Tag' rule should be enabled | string | `false` | no |
| event_selector | Specifies an event selector for enabling data event logging, It needs to be a list of map values. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this map variable | list | `<list>` | no |
| hard_expiry | Whether users are prevented from setting a new password after their password has expired (i.e. require administrator reset) | string | `false` | no |
| include_global_service_events | Specifies whether the trail is publishing events from global services such as IAM to the log files. | string | `true` | no |
| is_multi_region_trail | Specifies whether the trail is created in the current region or in all regions. | string | `true` | no |
| max_password_age | The number of days that an user password is valid. | string | `33` | no |
| minimum_password_length | Minimum length to require for user passwords. | string | `32` | no |
| monitor_readonly_user_name | The user name for the monitor read only user | string | `monitor_readonly` | no |
| password_reuse_prevention | The number of previous passwords that users are prevented from reusing. | string | `true` | no |
| read_only_group_name | Name for read-only group. | string | `read-only` | no |
| require_lowercase_characters | Whether to require lowercase characters for user passwords. | string | `true` | no |
| require_numbers | Whether to require numbers for user passwords. | string | `true` | no |
| require_symbols | Whether to require symbols for user passwords. | string | `true` | no |
| require_uppercase_characters | Whether to require uppercase characters for user passwords. | string | `true` | no |
| tag1Key | Specifies value of the Key for Tag1 | string | `` | no |
| tags | Map of tags to apply on the resources | map | `<map>` | no |
| trail_name | Name of the cloud trail. Required if the cloudtrail is enabled. | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| mfa_policy_arn | MFA Policy arn. |
| monitor_readonly_user_access_key_id | Access key id for the monitor readonly user |
| monitor_readonly_user_arn | ARN for the monitor readonly user |
| monitor_readonly_user_secret_access_key | Secret access key for the monitor readonly user |
| trail_arn | Cloud trail arn. |
