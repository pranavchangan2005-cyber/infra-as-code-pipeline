terraform {
  required_version = ">= 1.5.0"

   backend "s3" {
    bucket         = "infra-as-code-pipeline-tfstate-565122145389-ap-south-1"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "infra-as-code-pipeline-tf-locks"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
module "networking" {
  source = "../../modules/networking"

  project_name = "infra-as-code-pipeline"
}
output "vpc_id" {
  description = "ID of the development VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the development public subnets"
  value       = module.networking.public_subnet_ids
}
