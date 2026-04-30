output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the created public subnet"
  value       = module.network.public_subnet_id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.compute.instance_public_ip
}

output "website_url" {
  description = "URL to access the web server"
  value       = "http://${module.compute.instance_public_ip}"
}
