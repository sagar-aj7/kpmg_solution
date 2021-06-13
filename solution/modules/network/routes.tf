resource "aws_route" "tf-aws-igw-route" {
  route_table_id            = aws_route_table.tf-aws-public-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                =  aws_internet_gateway.tf-aws-internet-gateway.id
  depends_on                = [aws_route_table.tf-aws-public-route-table]
}

resource "aws_route" "tf-aws-nat-route" {
  route_table_id            = aws_route_table.tf-aws-private-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.tf-aws-nat-gateway.id
  depends_on                = [aws_route_table.tf-aws-private-route-table]
}