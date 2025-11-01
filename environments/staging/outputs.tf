# Staging environment outputs

output "ec2_instance_ids" {
  description = "IDs of staging EC2 instances"
  value       = module.compute.instance_ids
}

output "ec2_public_ips" {
  description = "Public IPs of staging instances"
  value       = module.compute.instance_public_ips
}

output "ec2_public_dns_urls" {
  description = "Clickable public DNS URLs for instances"
  value = [
    for dns in module.compute.instance_public_dns :
    "http://${dns}"
  ]
}

output "s3_bucket_name" {
  description = "Name of staging S3 bucket"
  value       = module.storage.bucket_id
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
}
