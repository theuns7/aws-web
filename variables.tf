variable "vpc_id" {
  description = "VPC ID to use for AWS resources"
  default = "vpc-06751eb265947af5d"
}

variable "subnet1_id" {
  description = "The first subnet to use"
  default = "subnet-0a358a2b47f42dd06"
}

variable "subnet2_id" {
  description = "The second subnet to use"
  default = "subnet-085390752680617a8"
}