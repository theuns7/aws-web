variable "vpc_id" {
  description = "VPC ID to use for AWS resources"
  default = "vpc-06751eb265947af5d"
}

variable "subnet_a_id" {
  description = "The first subnet to use"
  default = "subnet-0a358a2b47f42dd06"
}

variable "subnet_b_id" {
  description = "The second subnet to use"
  default = "subnet-085390752680617a8"
}

variable "region" {
  default = "us-east-1"
  type = string
  description = "The region you want to deploy the infrastructure in"
}
