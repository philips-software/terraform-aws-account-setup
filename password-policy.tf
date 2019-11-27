resource "aws_iam_account_password_policy" "pasword_policy" {
  count = var.enable_account_password_policy ? 1 : 0

  minimum_password_length        = var.minimum_password_length
  password_reuse_prevention      = var.password_reuse_prevention
  require_lowercase_characters   = var.require_lowercase_characters
  require_numbers                = var.require_numbers
  require_uppercase_characters   = var.require_uppercase_characters
  require_symbols                = var.require_symbols
  allow_users_to_change_password = var.allow_users_to_change_password
  max_password_age               = var.max_password_age
  hard_expiry                    = var.hard_expiry
}
