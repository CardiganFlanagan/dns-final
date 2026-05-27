output "primary_ip" {
  value = aws_instance.primary.public_ip
}

output "secondary_ip" {
  value = aws_instance.secondary.public_ip
}

output "caching_ip" {
  value = aws_instance.caching.public_ip
}

output "forwarding_ip" {
  value = aws_instance.forwarding.public_ip
}

# generate ansible inventory
resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory/hosts.yml"
  content  = <<-EOF
    all:
      children:
        primary:
          hosts:
            ns1:
              ansible_host: ${aws_instance.primary.public_ip}
        secondary:
          hosts:
            ns2:
              ansible_host: ${aws_instance.secondary.public_ip}
        caching:
          hosts:
            cache:
              ansible_host: ${aws_instance.caching.public_ip}
        forwarding:
          hosts:
            fwd:
              ansible_host: ${aws_instance.forwarding.public_ip}
        dns_servers:
          children:
            primary:
            secondary:
            caching:
            forwarding:
      vars:
        ansible_user: ubuntu
        ansible_ssh_private_key_file: ../terraform/dns-project-key.pem
        ansible_python_interpreter: /usr/bin/python3
        ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
  EOF
}