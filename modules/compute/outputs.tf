output "instance_ids" {
  description = "IDs of created EC2 instances"
  value       = aws_instance.app_server[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of instances"
  value       = aws_instance.app_server[*].public_ip
}

output "instance_public_dns" {
  description = "Public DNS names of instances"
  value       = aws_instance.app_server[*].public_dns
}

output "instance_private_ips" {
  description = "Private IP addresses of instances"
  value       = aws_instance.app_server[*].private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.instance_sg.id
}
