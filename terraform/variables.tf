variable "aws_region"{
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "dns-project-key"
}

variable "domain" {
  description = "DNS domain name"
  type        = string
  default     = "lab.com"
}

variable "dns_servers" {
  description = "DNS server definitions"
  type = map(object({
    private_ip = string
    hostname   = string
    role       = string
  }))
  default = {
    primary = {
      private_ip = "10.0.1.10"
      hostname   = "ns1"
      role       = "master"
    }
    secondary = {
      private_ip = "10.0.1.11"
      hostname   = "ns2"
      role       = "slave"
    }
    caching = {
      private_ip = "10.0.1.12"
      hostname   = "cache"
      role       = "cache"
    }
    forwarding = {
      private_ip = "10.0.1.13"
      hostname   = "fwd"
      role       = "forwarder"
    }
  }
}