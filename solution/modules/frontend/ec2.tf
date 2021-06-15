resource "aws_security_group" "tf-aws-ec2-security-group" {
  name = "ec2-sg"

  vpc_id = var.vpc_id

  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    security_groups = [aws_security_group.tf-aws-alb-security-group.id]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.public_subnets[0]}", "${var.public_subnets[1]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
  
  depends_on = [
      aws_security_group.tf-aws-alb-security-group
  ]
}

resource "aws_launch_configuration" "tf-aws-frontend-launch-configuration" {
  image_id        = "${data.aws_ami_ids.ubuntu.id}"
  instance_type   = "${var.app_instance_type}"
  security_groups = [aws_security_group.tf-aws-ec2-security-group.id]
  #TODO REMOVE
  key_name = "web-key"
  #name_prefix = "${var.name}-app-vm-"

  lifecycle {
    create_before_destroy = true
  }

depends_on = [
      aws_security_group.tf-aws-ec2-security-group
  ]

}

data "aws_subnet" "tf-data-aws-public-subnet" {
    count = "${length(var.private_subnets)}"
    id = var.private_subnets.*
}

resource "aws_autoscaling_group" "tf-aws-autoscaling-group" {
  launch_configuration = "${aws_launch_configuration.tf-aws-frontend-launch-configuration.id}"

  vpc_zone_identifier = ["${data.aws_subnet.tf-data-aws-public-subnet[0].id}", "${var.private_subnets[1].id}"]

  load_balancers    = [aws_lb.tf-aws-alb.name]
  health_check_type = "EC2"

  min_size = "${var.app_autoscale_min_size}"
  max_size = "${var.app_autoscale_max_size}"
/*
  tags {
    CreatedBy = "Terraform"
  }
*/
}

data "aws_ami_ids" "ubuntu" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}