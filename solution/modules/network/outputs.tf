output "vpc_id" {
  value = "${aws_vpc.tf-aws-vpc.id}"
}

output "public_subnets" {
  value = "${aws_subnet.tf-aws-public-subnet.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.tf-aws-private-subnet.*.id}"
}