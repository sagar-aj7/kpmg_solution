provider "aws" {
  region                  = var.region
  version                 = "3.0"
  shared_credentials_file = "~/.aws/credentials"
}