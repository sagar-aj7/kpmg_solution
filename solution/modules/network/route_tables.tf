resource "aws_route_table" "tf-aws-public-route-table" {
  vpc_id = aws_vpc.tf-aws-vpc.id

  tags = {
    CreatedBy   = "Terraform"
    Name        = "${aws_vpc.tf-aws-vpc.tags.Name}-public-rt"
  }
}

resource "aws_route_table" "tf-aws-private-route-table" {
  vpc_id = aws_vpc.tf-aws-vpc.id

  tags = {
    CreatedBy   = "Terraform"
    Name        = "${aws_vpc.tf-aws-vpc.tags.Name}-private-rt"
  }
}