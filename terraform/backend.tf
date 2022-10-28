terraform {
  backend "s3" {
    bucket = "aws-web-tfstate-us-east-1"
    region = "us-east-1"
    key = "main.terraform.tfstate"
    dynamodb_table = "tfstate-lock"
  }
}