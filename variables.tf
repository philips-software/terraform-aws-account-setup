variable "enable_mfa" {
  description = "Enable to force MFA usages."
  default     = true
}

variable "enable_admin_group" {
  description = "Create an admin group."
  default     = true
}

variable "enable_account_password_policy" {
  description = "Enable custom (strict) password policy."
  default     = true
}

variable "admin_group_name" {
  description = "Name of the admin group."
  default     = "admins"
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing."
  default     = true
}

variable "minimum_password_length" {
  description = "Minimum length to require for user passwords."
  default     = 32
}

variable "require_lowercase_characters" {
  description = "Whether to require lowercase characters for user passwords."
  default     = true
}

variable "require_numbers" {
  description = "Whether to require numbers for user passwords."
  default     = true
}

variable "require_uppercase_characters" {
  description = "Whether to require uppercase characters for user passwords."
  default     = true
}

variable "require_symbols" {
  description = "Whether to require symbols for user passwords."
  default     = true
}

variable "allow_users_to_change_password" {
  description = "Whether to allow users to change their own password"
  default     = true
}

variable "max_password_age" {
  description = "The number of days that an user password is valid."
  default     = 33
}

variable "hard_expiry" {
  description = "Whether users are prevented from setting a new password after their password has expired (i.e. require administrator reset)"
  default     = false
}

variable "enable_read_only" {
  description = "Creates a group with read-only IAM policy assigned to it."
  default     = false
}

variable "read_only_group_name" {
  description = "Name for read-only group."
  default     = "read-only"
}
