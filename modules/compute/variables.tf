variable "name_prefix" {
  description = "Prefix used for resource names"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "owner" {
  description = "Owner name displayed in the web page"
  type        = string
}

variable "web_message" {
  description = "Message displayed by the web server"
  type        = string
}
