# Production environment outputs

output "ec2_instance_ids" {
  description = "IDs of production EC2 instances"
  value       = module.compute.instance_ids
}

output "ec2_public_ips" {
  description = "Public IPs of production instances"
  value       = module.compute.instance_public_ips
}

output "ec2_public_dns" {
  description = "Public DNS names of EC2 instances"
  value       = module.compute.instance_public_dns
}

output "ec2_public_dns_urls" {
  description = "Clickable public DNS URLs for instances"
  value = [
    for dns in module.compute.instance_public_dns :
    "http://${dns}"
  ]
}

output "s3_bucket_name" {
  description = "Name of production S3 bucket"
  value       = module.storage.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of production S3 bucket"
  value       = module.storage.bucket_arn
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
}
