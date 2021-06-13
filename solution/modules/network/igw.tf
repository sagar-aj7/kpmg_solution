resource "aws_internet_gateway" "tf-aws-internet-gateway" {
  vpc_id = aws_vpc.tf-aws-vpc.id

  tags = {
    CreatedBy   = "Terraform"
  }
}