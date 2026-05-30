# ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# primary dns - ns1
resource "aws_instance" "primary" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.dns_key.key_name
  subnet_id              = aws_subnet.dns_subnet.id
  vpc_security_group_ids = [aws_security_group.dns.id]
  private_ip             = "192.168.1.10"
  tags = { Name = "ns1-primary" }
}

# secondary dns - ns2
resource "aws_instance" "secondary" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.dns_key.key_name
  subnet_id              = aws_subnet.dns_subnet.id
  vpc_security_group_ids = [aws_security_group.dns.id]
  private_ip             = "192.168.1.11"
  tags = { Name = "ns2-secondary" }
}

# caching dns
resource "aws_instance" "caching" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.dns_key.key_name
  subnet_id              = aws_subnet.dns_subnet.id
  vpc_security_group_ids = [aws_security_group.dns.id]
  private_ip             = "192.168.1.12"
  tags = { Name = "cache" }
}

# forwarding dns
resource "aws_instance" "forwarding" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.dns_key.key_name
  subnet_id              = aws_subnet.dns_subnet.id
  vpc_security_group_ids = [aws_security_group.dns.id]
  private_ip             = "192.168.1.13"
  tags = { Name = "fwd" }
}
