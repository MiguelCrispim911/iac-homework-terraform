variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "iac-homework-terraform"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner of the infrastructure"
  type        = string
  default     = "Luis Crispim"
}

variable "web_message" {
  description = "Message displayed by the web server"
  type        = string
  default     = "Hi, I am Luis Crispim and this is my IaC"
}
