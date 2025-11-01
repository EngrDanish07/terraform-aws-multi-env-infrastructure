# Staging environment configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Owner       = "DevOps Team"
    }
  }
}

# Local variables for common configuration
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Compute
module "compute" {
  source = "../../modules/compute"

  environment    = var.environment
  instance_count = var.instance_count
  instance_type  = var.instance_type
  ami            = var.ami
  key_name       = var.key_name

  common_tags = local.common_tags
}

# Storage
module "storage" {
  source = "../../modules/storage"

  environment       = var.environment
  bucket_name       = "${var.project_name}-assets"
  enable_versioning = true

  common_tags = local.common_tags
}

#Database
module "database" {
  source = "../../modules/database"

  environment           = var.environment
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = 15
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password

  common_tags = local.common_tags
}