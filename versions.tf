terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "luis-iac-homework"

    workspaces {
      name = "iac-homework-terraform"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
