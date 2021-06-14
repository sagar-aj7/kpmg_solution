# configure s3 bucket for tf state
resource "aws_s3_bucket" "tf-aws-s3-bucket" {
  bucket = "${var.region}-${var.s3_bucket_name}"

  lifecycle {
    prevent_destroy = true
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
    CreatedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "tf-aws-s3-bucket-policy" {
  bucket = aws_s3_bucket.tf-aws-s3-bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
  "Id": "Policy1623613509287",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1623613498956",
      "Action": [ s3:GetBucketAcl
        s3:GetBucketLogging
        s3:GetObject
        s3:GetObjectAcl
        s3:ListBucket
        s3:PutBucketLogging
        s3:PutObject
        s3:PutObjectAcl
      ]
      "Effect": "Allow",
      Resource = [
          aws_s3_bucket.tf-aws-s3-bucket.arn,
          "${aws_s3_bucket.tf-aws-s3-bucket.arn}/*",
        ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::231816715996:user/terraform"
        ]
      }
    }
  ]
})
}