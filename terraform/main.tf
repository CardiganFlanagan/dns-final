terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ssh key
resource "tls_private_key" "dns_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "dns_key" {
  key_name   = var.key_name
  public_key = tls_private_key.dns_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.dns_key.private_key_pem
  filename        = "${path.module}/dns-project-key.pem"
  file_permission = "0400"
}

# vpc
resource "aws_vpc" "dns_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "dns-project-vpc" }
}

# subnet
resource "aws_subnet" "dns_subnet" {
  vpc_id                  = aws_vpc.dns_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = { Name = "dns-project-subnet" }
}

# internet gateway
resource "aws_internet_gateway" "dns_igw" {
  vpc_id = aws_vpc.dns_vpc.id
  tags = { Name = "dns-project-igw" }
}

# route table
resource "aws_route_table" "dns_rt" {
  vpc_id = aws_vpc.dns_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dns_igw.id
  }
  tags = { Name = "dns-project-rt" }
}

resource "aws_route_table_association" "dns_rta" {
  subnet_id      = aws_subnet.dns_subnet.id
  route_table_id = aws_route_table.dns_rt.id
}
