terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Added backend for state management
  backend "s3" {
   bucket  = "state-bucket-terraform-201"
   region = "us-east-1"
   key    = "terraform.tfstate"
   encrypt = true
 }

}

provider "aws" {
  region = "us-east-1"
}