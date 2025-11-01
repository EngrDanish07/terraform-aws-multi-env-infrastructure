variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "cloudinfra"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-06d455b8b50b0de4d"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "terra-key-ec2"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "devdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "devadmin"
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
