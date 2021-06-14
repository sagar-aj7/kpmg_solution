module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "frontend-alb"

  load_balancer_type = "application"

  vpc_id          = module.dev-network.aws_vpc.tf-aws-vpc.id
  subnets         = module.dev-network.aws_subnet.tf-aws-public-subnet.*.id
  security_groups = aws_security_group.tf-aws-alb-security-group

  access_logs = {
    bucket = aws_s3_bucket.tf-log-aws-s3-bucket
  }
  /*
  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "i-0123456789abcdefg"
          port = 80
        },
        {
          target_id = "i-a1b2c3d4e5f6g7h8i"
          port = 8080
        }
      ]
    }
  ]
*/
  /*
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
      target_group_index = 0
    }
  ]
*/
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    CreatedBy = "Terraform"
  }
}

# configure s3 bucket for logging
resource "aws_s3_bucket" "tf-log-aws-s3-bucket" {
  bucket = "${var.region}-${var.s3_bucket_name}"

  lifecycle {
    prevent_destroy = false
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "tf-log-aws-s3-bucket-policy" {
  bucket = aws_s3_bucket.tf-log-aws-s3-bucket

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    "Id" : "Policy1623613509287",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Stmt1623613498946",
        "Action" : "s3:*",
        "Effect" : "Allow",
        Resource = [
          aws_s3_bucket.tf-log-aws-s3-bucket.arn,
          "${aws_s3_bucket.tf-log-aws-s3-bucket.arn}/*",
        ],
        "Principal" : {
          "AWS" : [
            module.alb.lb_arn
          ]
        }
      }
    ]
  })
}

resource "aws_security_group" "tf-aws-alb-security-group" {
  name        = var.alb_security_group_name
  description = "Allow TLS inbound traffic"
  vpc_id      = module.dev-network.aws_vpc.tf-aws-vpc.id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


module "dev-frontend" {
  source                 = "../../modules/frontend"
  region                 = "us-east-1"
  app_port               = "80"
  app_instance_type      = "t2.micro"
  app_autoscale_min_size = "2"
  app_autoscale_max_size = "2"

}
