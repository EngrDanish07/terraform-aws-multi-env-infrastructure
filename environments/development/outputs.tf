output "ec2_instance_id" {
  description = "ID of development EC2 instance"
  value       = module.compute.instance_ids[0]
}

output "ec2_public_ip" {
  description = "Public IP of development instance"
  value       = module.compute.instance_public_ips[0]
}

output "ec2_public_dns_url" {
  description = "Clickable public DNS URL for instance"
  value       = "http://${module.compute.instance_public_dns[0]}"
}

output "s3_bucket_name" {
  description = "Name of development S3 bucket"
  value       = module.storage.bucket_id
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = module.database.db_endpoint
}
