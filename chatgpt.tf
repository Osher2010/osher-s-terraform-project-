#---provider---
provider "aws" {
    access_key = "access_key"
    secret_key = "secret_key"
    region     = "ap-northeast-1"
}

#---vpc_create---
# Create a VPC
resource "aws_vpc" "osher-vpc" {
  cidr_block = "10.0.0.0/16"
}

#---security_group---
resource "aws_security_group" "osher-security_group" {
  name   = "sg"
  vpc_id = aws_vpc.osher-vpc.id  # Updated reference to use the correct VPC name

  ingress = []
  egress  = []
}

#---subnet---
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.osher-vpc.id  # Updated reference to use the correct VPC name
  cidr_block = "172.20.0.0/16"
}

resource "aws_subnet" "in_secondary_cidr" {
  vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
  cidr_block = "172.20.0.0/24"
}

#---ec2---
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "ubuntu_ami"
    values = ["ami-09a81b370b76de6a2"]
    
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "Osher-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "Osher's_project"
  }
}
