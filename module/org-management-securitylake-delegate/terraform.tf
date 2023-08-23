terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.7.0"
    }
  }

  cloud {
    organization = "MZC-ORG"

    workspaces {
      name = "CTC-3507-AWS-Organizations"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

