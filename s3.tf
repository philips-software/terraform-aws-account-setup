// Terraform State S3 buacket  
resource "aws_s3_bucket" "kabisa_terraform_statefiles_bucket" {
  count  = var.s3_bucket_state_file_creation ? 1 : 0
  bucket = var.s3_bucket_state_file_name

  tags = {
    Terraform = true
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_private_acl" {
  count  = var.s3_bucket_state_file_creation ? 1 : 0
  bucket     = aws_s3_bucket.kabisa_terraform_statefiles_bucket[count.index].id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  count  = var.s3_bucket_state_file_creation ? 1 : 0
  bucket = aws_s3_bucket.kabisa_terraform_statefiles_bucket[count.index].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  count  = var.s3_bucket_state_file_creation ? 1 : 0
  bucket = aws_s3_bucket.kabisa_terraform_statefiles_bucket[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encrypt_rule" {
  count  = var.s3_bucket_state_file_creation ? 1 : 0
  bucket = aws_s3_bucket.kabisa_terraform_statefiles_bucket[count.index].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}