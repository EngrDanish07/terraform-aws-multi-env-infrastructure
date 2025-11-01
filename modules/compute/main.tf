# EC2 instances with security group and basic configuration
# Designed to be reusable across all environments

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
}

# Fetch the default VPC
resource "aws_default_vpc" "default" {}

# Fetch subnets from the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

# Security group for EC2 instances
resource "aws_security_group" "instance_sg" {
  name_prefix = "${var.environment}-instance-sg-"
  description = "Security group for ${var.environment} EC2 instances"
  vpc_id      = aws_default_vpc.default.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-instance-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Allow SSH (port 22)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.instance_sg.id
  description       = "Allow SSH access"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.instance_sg]
}

# Allow HTTP (port 80)
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.instance_sg.id
  description       = "Allow HTTP traffic"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.instance_sg]
}

# Allow HTTPS (port 443)
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.instance_sg.id
  description       = "Allow HTTPS traffic"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"

  depends_on = [aws_security_group.instance_sg]
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_egress" {
  security_group_id = aws_security_group.instance_sg.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  depends_on = [aws_security_group.instance_sg]
}

# EC2 instances
resource "aws_instance" "app_server" {
  count = var.instance_count

  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  subnet_id                   = element(data.aws_subnets.default.ids, count.index)
  user_data                   = file("${path.module}/user_data.sh")
  associate_public_ip_address = true

  tags = merge(
    var.common_tags,
    {
      Name  = "${var.environment}-app-server-${count.index + 1}"
      Role  = "application-server"
      Index = count.index + 1
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
