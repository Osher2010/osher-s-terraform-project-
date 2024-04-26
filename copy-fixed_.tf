# ---provider---
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ---provider_config---
provider "aws" {
  region = "ap-northeast-1"
}

# ---vpc_create---
resource "aws_vpc" "osher-vpc" {
  cidr_block = "10.0.0.0/16"
}

# ---security_group---
resource "aws_security_group" "osher-security_group" {
  name   = "sg"
  vpc_id = aws_vpc.osher-vpc.id

  ingress = []
  egress  = []
}

# ---subnet---
resource "aws_subnet" "in_secondary_cidr" {
  vpc_id     = aws_vpc.osher-vpc.id
  cidr_block = "172.20.0.0/24"
}

# ---ec2---
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu-Server" {
  ami           = data.aws_ami.ubuntu.image_id
  instance_type = "t2.micro"

  tags = {
    Name = "Osher's_project"
  }
}
