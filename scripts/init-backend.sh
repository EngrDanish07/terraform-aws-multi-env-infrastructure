#!/bin/bash
# Initialize Terraform backend (S3 + DynamoDB)
# Run this script once before deploying any environment

set -euo pipefail

cd "$(dirname "$0")/../backend-setup"

if ! command -v aws >/dev/null 2>&1; then
  echo "AWS CLI not found. Install and configure AWS CLI first."
  exit 1
fi

if ! aws sts get-caller-identity >/dev/null 2>&1; then
  echo "AWS CLI credentials are not configured or invalid. Run 'aws configure'."
  exit 1
fi

terraform init
terraform plan -out=backend.tfplan
terraform apply backend.tfplan
rm -f backend.tfplan

echo "Backend created. Update environment backend.tf files if bucket name changed."
