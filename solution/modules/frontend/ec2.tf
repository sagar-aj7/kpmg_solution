resource "aws_security_group" "tf-aws-ec2-security-group" {
  name = "ec2-sg"

  vpc_id = module.dev-network.aws_vpc.tf-aws-vpc

  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    security_groups = module.dev-alb.aws_security_group.tf-aws-alb-security-group
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${module.dev-network.aws_subnet.tf-aws-public-subnet[0]}", "${module.dev-network.aws_subnet.tf-aws-public-subnet[1]}"]
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
  
  tags {
    CreatedBy = "Terraform"
  }
}

resource "aws_launch_configuration" "tf-aws-frontend-launch-configuration" {
  image_id        = "${data.aws_ami_ids.ubuntu.id}"
  instance_type   = "${var.app_instance_type}"
  security_groups = aws_security_group.tf-aws-ec2-security-group.id
  #TODO REMOVE
  key_name = "web-key"
  #name_prefix = "${var.name}-app-vm-"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "tf-aws-autoscaling-group" {
  launch_configuration = "${aws_launch_configuration.tf-aws-frontend-launch-configuration.id}"

  vpc_zone_identifier = ["${module.dev-network.aws_subnet.tf-aws-private-subnet[0].cidr_block}", "${module.dev-network.aws_subnet.tf-aws-private-subnet[1].cidr_block}"]

  load_balancers    = ["${module.alb.lb_id}"]
  health_check_type = "EC2"

  min_size = "${var.app_autoscale_min_size}"
  max_size = "${var.app_autoscale_max_size}"

  tags {
    CreatedBy = "Terraform"
  }

}

data "aws_ami_ids" "ubuntu" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}