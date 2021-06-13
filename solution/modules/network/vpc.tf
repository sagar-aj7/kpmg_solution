resource "aws_vpc" "tf-aws-vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    CreatedBy   = "Terraform"
    Name        = "3-tier-vpc"
  }
}