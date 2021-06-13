resource "aws_nat_gateway" "tf-aws-nat-gateway" {
  allocation_id = aws_eip.tf-aws-eip.id
  subnet_id     = aws_subnet.tf-aws-public-subnet[0].id

  tags = {
    Name = "gw NAT"
    CreatedBy   = "Terraform"
  }

  depends_on = [aws_internet_gateway.tf-aws-internet-gateway]
}