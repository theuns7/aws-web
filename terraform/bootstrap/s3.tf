resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "aws-web-tfstate-us-east-1"
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
