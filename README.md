# Terraform module configure IAM in a new Amazon account_setup

This terraform modules configures the following in IAM:

- Creates a policy to enforce MFA
- Sets a script password policy
- Creates a group with admin privileges, with MFA enable_admin_group
- Creates a group with read-only policy (disabled by default)

All features can be enabled or disabled, default is enabled.

## Usage

### Example usages

```terraform
module "account_setup" {
  source = "philips-software/account-setup/aws"
  version = "1.0.0"

  # Or via github
  # source = "github.com/philips-software/terraform-aws-account-setup?ref=1.0.0"

}

```

## Inputs

| Name                           | Description                                                                                                                 | Type   | Default     | Required |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------- | :----: | :---------: | :------: |
| admin_group_name               | Name of the admin group..                                                                                                   | string | `admins`    | no       |
| allow_users_to_change_password | Whether to allow users to change their own password                                                                         | string | `true`      | no       |
| enable_account_password_policy | Enable custom (strict) password policy.                                                                                     | string | `true`      | no       |
| enable_admin_group             | Create an admin group.                                                                                                      | string | `true`      | no       |
| enable_mfa                     | Enable to force MFA usages.                                                                                                 | string | `true`      | no       |
| enable_read_only               | Creates a group with the pre-defined read-only IAM policy assigned to it                                                    | string | `false`     | no       |
| hard_expiry                    | Whether users are prevented from setting a new password after their password has expired (i.e. require administrator reset) | string | `false`     | no       |
| max_password_age               | The number of days that an user password is valid.                                                                          | string | `33`        | no       |
| minimum_password_length        | Minimum length to require for user passwords.                                                                               | string | `32`        | no       |
| password_reuse_prevention      | The number of previous passwords that users are prevented from reusing.                                                     | string | `true`      | no       |
| read_only_group_name           | Name for read-only group.                                                                                                   | string | `read-only` | no       |
| require_lowercase_characters   | Whether to require lowercase characters for user passwords.                                                                 | string | `true`      | no       |
| require_numbers                | Whether to require numbers for user passwords.                                                                              | string | `true`      | no       |
| require_symbols                | Whether to require symbols for user passwords.                                                                              | string | `true`      | no       |
| require_uppercase_characters   | Whether to require uppercase characters for user passwords.                                                                 | string | `true`      | no       |

## Outputs

| Name           | Description     |
| -------------- | --------------- |
| mfa_policy_arn | MFA Policy arn. |
