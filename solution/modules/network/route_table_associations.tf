resource "aws_route_table_association" "tf-aws-public-route-table-association" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.tf-aws-public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.tf-aws-public-route-table.id}"
}

resource "aws_route_table_association" "tf-aws-private-route-table-association" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.tf-aws-private-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.tf-aws-private-route-table.id}"
}