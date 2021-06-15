module "dev-network" {
  source          = "../modules/network"
  region          = "us-east-1"
  vpc_cidr_block  = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "dev_frontend" {
  source                  = "../modules/frontend"
  region                  = "us-east-1"
  app_port                = "80"
  app_instance_type       = "t2.micro"
  app_autoscale_min_size  = "2"
  app_autoscale_max_size  = "2"
  alb_name                = "frontend-alb"
  s3_alb_logs_bucket_name = "alb_logs_bucket"
  alb_security_group_name = "alb-security-group"
  vpc_id = "${module.dev-network.vpc_id}"
  public_subnets = "${module.dev-network.public_subnets}"
  private_subnets = "${module.dev-network.private_subnets}"

}