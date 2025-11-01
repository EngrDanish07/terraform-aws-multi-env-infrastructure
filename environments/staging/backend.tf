# Backend configuration for staging environment
# Stores state in S3 with DynamoDB locking

terraform {
  backend "s3" {
    bucket         = "my-cloudinfra-state-bucket-2025"    # Match backend-setup
    key            = "staging/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "cloudinfra-lock-table"
    encrypt        = true
  }
}
