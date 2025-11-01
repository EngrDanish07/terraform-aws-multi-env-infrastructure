# Multi-Environment AWS Infrastructure with Terraform

A practical, production-ready Terraform project that sets up complete AWS infrastructure across three isolated environments. Built to demonstrate clean modular design and real-world DevOps practices.

---

## What This Project Does

If you've ever wondered how to properly structure Terraform for multiple environments without copy-pasting the same code three times, this project shows you exactly that.

It provisions a complete AWS stack: EC2 instances, RDS databases, and S3 storage across Production, Staging, and Development environments. Each environment is completely isolated with its own state file and configuration, but they all share the same reusable modules.

The setup uses a remote backend (S3 + DynamoDB) for state management, which means multiple people can work on the infrastructure without stepping on each other's toes. State locking prevents those "oh no, someone else was running terraform apply at the same time" moments.

### Problems It Solves

**Environment Management:**
- No more maintaining duplicate Terraform code for each environment
- Each environment (prod, staging, dev) stays completely isolated
- You can destroy dev without worrying about touching production

**State Management:**
- Safe infrastructure changes with state locking
- Remote backend means you can work from anywhere
- State versioning in S3 gives you history and rollback capability

**Code Organization:**
- Module reusability saves hours of repetitive work
- Clear structure makes it easy to find and update resources
- Consistent patterns across all environments

**Automation:**
- EC2 instances configure themselves on boot
- No manual setup needed after deployment
- Helper scripts handle common operations

## Infrastructure Components

Each environment gets:
- **EC2 instances** running Amazon Linux 2023 with nginx pre-installed
- **RDS MariaDB database** (Free Tier eligible)
- **S3 bucket** for storage (versioning enabled in prod/staging)
- **Security groups** configured for HTTP, HTTPS, and SSH
- **User data automation** that sets up everything on first boot

The key difference between environments is scale:
- **Production**: 2 EC2 instances for availability
- **Staging**: 1 EC2 instance (mirrors prod but smaller)
- **Development**: 1 EC2 instance with minimal features

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Cloud (us-west-2)                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   Production    │  │     Staging     │  │  Development    │  │
│  ├─────────────────┤  ├─────────────────┤  ├─────────────────┤  │
│  │ • 2x EC2 (t3)   │  │ • 1x EC2 (t3)   │  │ • 1x EC2 (t3)   │  │
│  │ • RDS MariaDB   │  │ • RDS MariaDB   │  │ • RDS MariaDB   │  │
│  │ • S3 Bucket     │  │ • S3 Bucket     │  │ • S3 Bucket     │  │
│  │ • Versioning ON │  │ • Versioning ON │  │ • Versioning OFF│  │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘  │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         Remote State Backend (Shared)                    │   │
│  │  • S3 Bucket (state storage)                             │   │
│  │  • DynamoDB Table (state locking)                        │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
terraform-aws-multi-env-infrastructure/
├── backend-setup/                    # One-time backend setup
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
│
├── modules/                          # Reusable modules
│   ├── compute/                      # EC2 module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── user_data.sh
│   │
│   ├── storage/                      # S3 module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── database/                     # RDS module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/                     # Environment-specific configs
│   ├── production/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── outputs.tf
│   │   └── backend.tf
│   │
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── outputs.tf
│   │   └── backend.tf
│   │
│   └── development/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── outputs.tf
│       └── backend.tf
│
└── scripts/                          # Helper scripts
    ├── init-backend.sh
    └── deploy.sh
```

### What Each Folder Does

**`backend-setup/`**  
Creates the S3 bucket and DynamoDB table that Terraform uses to store state files. You only run this once at the very beginning.

**`modules/`**  
Contains reusable Terraform modules for compute (EC2), storage (S3), and database (RDS). Write once, use everywhere.

**`environments/`**  
Each environment (production, staging, development) has its own folder with specific configurations and variable values. They all use the same modules but with different settings.

**`scripts/`**  
Automation scripts to make your life easier. `init-backend.sh` sets up the remote backend, and `deploy.sh` handles deployment/destruction of environments.

---

## Prerequisites

Before you start, make sure you have:

- **AWS Account** (Free Tier works great for this)
- **AWS CLI** configured with credentials (`aws configure`)
- **Terraform** installed (v1.0 or newer)
- **SSH key pair** created in AWS with the name `terra-key-ec2`

If you don't have an SSH key pair yet:
```bash
aws ec2 create-key-pair \
  --key-name terra-key-ec2 \
  --query 'KeyMaterial' \
  --output text > terra-key-ec2.pem

chmod 400 terra-key-ec2.pem
```

---

## How to Use

### 1. Clone the Repository

```bash
git clone https://github.com/EngrDanish07/terraform-aws-multi-env-infrastructure
cd terraform-aws-multi-env-infrastructure
```

### 2. Set Up the Backend (One-Time Only)

This creates the S3 bucket and DynamoDB table for storing Terraform state:

```bash
cd scripts
./init-backend.sh
```

Wait for it to complete. It'll create the remote backend that all three environments will share.

### 3. Deploy an Environment

Start with development (smallest resources):

```bash
./deploy.sh development apply
```

Or deploy production:

```bash
./deploy.sh production apply
```

The script will:
- Initialize Terraform
- Show you what will be created
- Deploy everything
- Output the URLs and connection info

### 4. Access Your Infrastructure

After deployment completes, you'll see output like:

```
EC2 INSTANCES:
Instance 1: http://ec2-54-123-45-67.us-west-2.compute.amazonaws.com

```

Once deployment completes, open the public EC2 URL in your browser. You’ll see a simple Nginx landing page confirming that the environment was provisioned successfully using Terraform.

### 5. Destroy When Done

To avoid AWS charges:

```bash
./deploy.sh development destroy
```

Or destroy all environments:

```bash
./deploy.sh production destroy
./deploy.sh staging destroy
./deploy.sh development destroy
```

---

## Manual Deployment (Without Scripts)

If you prefer doing things manually:

```bash
# Set up backend first
cd backend-setup
terraform init
terraform apply

# Then deploy an environment
cd ../environments/production
terraform init
terraform plan
terraform apply

# Destroy when done
terraform destroy
```

---

## Important Notes

### About terraform.tfvars Files

The `.tfvars` files in this repo contain example values including a demo database password. **This is only okay for learning projects.**

In a real production environment:
- Never commit `.tfvars` files with actual credentials
- Use environment variables (`TF_VAR_db_password`)
- Or use AWS Secrets Manager
- Add `*.tfvars` to your `.gitignore`

### AMI and Region

This project uses:
- **AMI**: Amazon Linux 2023 (`ami-06d455b8b50b0de4d`)
- **Region**: us-west-2 (Oregon)

If you're in a different region, update the AMI ID in `modules/compute/variables.tf` to match your region's Amazon Linux 2023 AMI.

### Cost Considerations

With AWS Free Tier:
- **EC2 t3.micro**: 750 hours/month free
- **RDS db.t3.micro**: 750 hours/month free
- **S3**: First 5GB free

Running all three environments simultaneously will exceed Free Tier limits. Deploy one at a time, or be prepared for small charges (~$5-10/month).

---

## What Makes This Project Different

Instead of stopping at basic EC2 provisioning, this setup demonstrates how to scale that knowledge into a clean, multi-environment Terraform workflow.

**Key features:**

✅ **Proper module structure** EC2, RDS, and S3 are separate modules you can reuse  
✅ **Environment isolation**   Each environment has its own state file and config  
✅ **Remote state backend**    S3 + DynamoDB for team collaboration and safety  
✅ **Automated provisioning**  EC2 instances configure themselves on boot  
✅ **Helper scripts**          Automate common tasks instead of typing everything manually  
✅ **Clean organization**      Easy to navigate, understand, and extend  

---

## Extending This Project

This setup is intentionally simple but designed to grow with the needs.
Here are some ways we could extend or improve it:

- Add a custom VPC with public/private subnets
- Set up an Application Load Balancer for production
- Implement Auto Scaling Groups
- Add CloudWatch alarms and monitoring
- Integrate with CI/CD pipelines (GitHub Actions, GitLab CI)
- Add proper secrets management with AWS Secrets Manager
- Implement infrastructure testing with Terratest

---

## Common Issues

**"State locking error"**  
Someone else is running Terraform, or a previous run didn't clean up. Check DynamoDB for locks, or use `terraform force-unlock`.

**"AMI not found"**  
You're probably in a different AWS region. Update the AMI ID in `modules/compute/variables.tf`.

**"SSH connection refused"**  
Security group might not be configured yet, or your IP

**"Free Tier restriction error"**  
You're trying to create too many resources. Deploy one environment at a time, or use smaller instance types.

---

This setup is clean, practical, and easy to extend. Perfect for anyone learning Terraform or setting up their first AWS project from scratch. If you find it helpful, feel free to fork it, star it, or suggest improvements.

Built with way too much tea and a lot of trial and error :)
