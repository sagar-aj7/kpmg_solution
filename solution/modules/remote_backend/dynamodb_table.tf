# configure aws dynamodb table for state locks
resource "aws_dynamodb_table" "tf-aws-dynamodb-table" {
  name         = "${var.region}-${var.dynamodb_table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    CreatedBy   = "Terraform"
  }
}