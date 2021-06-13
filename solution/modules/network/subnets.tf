resource "aws_subnet" "tf-aws-public-subnet" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = aws_vpc.tf-aws-vpc.id
  cidr_block              = "${var.public_subnets[count.index]}"
#  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    CreatedBy   = "Terraform"
  }
}

resource "aws_subnet" "tf-aws-private-subnet" {
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = aws_vpc.tf-aws-vpc.id
  cidr_block              = "${var.private_subnets[count.index]}"
  #availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    CreatedBy   = "Terraform"
  }
}