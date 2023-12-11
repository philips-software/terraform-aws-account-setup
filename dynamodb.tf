// Terraform State dynamodb table
resource "aws_dynamodb_table" "kabisa_terraform_lockfiles_dynamodb_table" {
  count = var.dynamodb_tables_creation ? 1 : 0
  name           = var.dynamodb_tables_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Terraform = true
  }
}
