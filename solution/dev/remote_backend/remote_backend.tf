module "dev-remote-backend" {
    source              = "../../modules/remote_backend"
    region              = var.region
    s3_bucket_name      = var.s3_bucket_name
    dynamodb_table_name = var.dynamodb_table_name
}