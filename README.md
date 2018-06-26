# Terraform module configure IAM in a new Amazon account_setup

This terraform modules configures the following in IAM.
- Creates a policy to enforce MFA
- Sets a script password policy
- Creates an group with admin privileges, with MFA enable_admin_group

All features can be enabled or disabled, default is enabled.


## Usage

### Example usages
```
module "efs" {
  source = "philips-software/account-setup/aws"
  version = "1.0.0"

  # Or via github
  # source = "github.com/philips-software/terraform-aws-account-setup?ref=1.0.0"

  environment    = "${var.environment}"
  subnet_count   = "3"
  subnet_ids     = "${var.private_subnet_ids}"
  vpc_id         = "${var.vpc_id}"

}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allow_users_to_change_password | Whether to allow users to change their own password | string | `true` | no |
| enable_account_password_policy | Enable custom (strict) password policy. | string | `true` | no |
| enable_admin_group | Create an admin group. | string | `true` | no |
| enable_mfa | Enable to force MFA usages. | string | `true` | no |
| hard_expiry | Whether users are prevented from setting a new password after their password has expired (i.e. require administrator reset) | string | `false` | no |
| max_password_age | The number of days that an user password is valid. | string | `33` | no |
| minimum_password_length | Minimum length to require for user passwords. | string | `32` | no |
| password_reuse_prevention | The number of previous passwords that users are prevented from reusing. | string | `true` | no |
| require_lowercase_characters | Whether to require lowercase characters for user passwords. | string | `true` | no |
| require_numbers | Whether to require numbers for user passwords. | string | `true` | no |
| require_symbols | Whether to require symbols for user passwords. | string | `true` | no |
| require_uppercase_characters | Whether to require uppercase characters for user passwords. | string | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| mfa_policy_arn | MFA Policy arn. |
