resource "aws_route_table" "tf-aws-public-route-table" {
  vpc_id = aws_vpc.tf-aws-vpc.id

  tags = {
    CreatedBy   = "Terraform"
  }
}

resource "aws_route_table" "tf-aws-private-route-table" {
  vpc_id = aws_vpc.tf-aws-vpc.id

  tags = {
    CreatedBy   = "Terraform"
  }
}