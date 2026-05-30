#!/bin/bash
echo "=== Creating AWS infrastructure ==="
cd terraform
terraform init
terraform apply -auto-approve

echo "=== Waiting for servers to boot ==="
sleep 30

echo "=== Configuring DNS servers ==="
cd ../ansible
ansible-playbook -i inventory/hosts.yml site.yml

echo "=== Done! ==="
cd ../terraform
echo "Primary:    $(terraform output -raw primary_ip)"
echo "Secondary:  $(terraform output -raw secondary_ip)"
echo "Caching:    $(terraform output -raw caching_ip)"
echo "Forwarding: $(terraform output -raw forwarding_ip)"