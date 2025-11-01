#!/bin/bash
# Deploy script for Terraform environments
# Usage: ./deploy.sh <environment> <action>
# Example: ./deploy.sh production apply

set -euo pipefail

ENVIRONMENT=${1:-}
ACTION=${2:-plan}

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <environment> [plan|apply|destroy]"
    echo "Environments: production, staging, development"
    exit 1
fi

if [[ ! "$ENVIRONMENT" =~ ^(production|staging|development)$ ]]; then
    echo "Invalid environment: $ENVIRONMENT"
    exit 1
fi

ENV_DIR="$(dirname "$0")/../environments/$ENVIRONMENT"

if [ ! -d "$ENV_DIR" ]; then
    echo "Environment directory not found: $ENV_DIR"
    exit 1
fi

cd "$ENV_DIR"

echo "Deploying $ENVIRONMENT - action: $ACTION"

if [ "$ENVIRONMENT" = "production" ] && [ "$ACTION" = "destroy" ]; then
    echo "WARNING: You are about to destroy PRODUCTION infrastructure!"
    read -p "Type 'yes' to confirm: " confirmation
    if [ "$confirmation" != "yes" ]; then
        echo "Cancelled."
        exit 1
    fi
fi

if [ ! -d ".terraform" ]; then
    terraform init
fi

case "$ACTION" in
  plan)
    terraform plan
    ;;
  apply)
    terraform plan -out=tfplan
    terraform apply tfplan
    rm -f tfplan
    echo ""
    terraform output
    ;;
  destroy)
    terraform destroy
    ;;
  *)
    echo "Unsupported action: $ACTION"
    exit 1
    ;;
esac
