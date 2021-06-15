resource "aws_lb" "tf-aws-alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf-aws-alb-security-group.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.tf-log-aws-s3-bucket.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    CreatedBy = "Terraform"
  }

  depends_on = [
      aws_security_group.tf-aws-alb-security-group,
      aws_s3_bucket.tf-log-aws-s3-bucket
  ]
}

resource "aws_security_group" "tf-aws-alb-security-group" {
  name        = var.alb_security_group_name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# configure s3 bucket for logging
resource "aws_s3_bucket" "tf-log-aws-s3-bucket" {
  bucket = "${var.region}-${var.s3_alb_logs_bucket_name}"

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
  bucket = aws_s3_bucket.tf-log-aws-s3-bucket.id

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
            aws_lb.tf-aws-alb.arn
          ]
        }
      }
    ]
  })
  depends_on = [
      aws_s3_bucket.tf-log-aws-s3-bucket
  ]
}


