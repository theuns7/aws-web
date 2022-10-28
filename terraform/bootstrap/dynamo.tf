resource "aws_dynamodb_table" "tfstate_lock" {
  name = "tfstate-lock"
  hash_key = "LockID"

  billing_mode = "PAY_PER_REQUEST"
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}