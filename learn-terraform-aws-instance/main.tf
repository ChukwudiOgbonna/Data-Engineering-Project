terraform {
    # provides where to store terraform state data files which are used to keep track of metadata of resources
    backend "s3" {
    bucket = "terraformstatedata"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "app_server" {
  ami           = "ami-0149b2da6ceec4bb0"
  instance_type = "t2.micro"
 
  tags = {
   Name = var.instance_name
  }
}
resource "aws_s3_bucket" "b" {
  bucket = "chuks-bucket-12"

  tags = {
    Name        = "chuks"
    Environment = "Dev"
  }
}


