variable "region" {
	type 		= string
}

variable "vpc_id" {}

variable "public_subnets" {}

variable "private_subnets" {}


variable "alb_name" {
	type 		= string
}

variable "alb_security_group_name" {
	type 		= string
}

variable "s3_alb_logs_bucket_name" {
	type 		= string
}


variable "app_port" {
	type 		= string
}

variable "app_instance_type" {
	type 		= string
}

variable "app_autoscale_min_size" {
	type 		= string
}

variable "app_autoscale_max_size" {
	type 		= string
}