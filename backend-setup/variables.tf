variable "aws_region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name prefix for all backend resources"
  type        = string
  default     = "cloudinfra"
}
