#!/bin/bash
echo "=== Testing DNS Infrastructure ==="
echo ""

cd terraform
PRIMARY=$(terraform output -raw primary_ip)
SECONDARY=$(terraform output -raw secondary_ip)
CACHING=$(terraform output -raw caching_ip)
FORWARDING=$(terraform output -raw forwarding_ip)
cd ..

echo "--- Primary DNS ($PRIMARY) ---"
echo "A record:  $(dig +short ns1.lab.com @$PRIMARY)"
echo "PTR:       $(dig +short -x 192.168.1.10 @$PRIMARY)"
echo "NS:        $(dig +short lab.com NS @$PRIMARY)"
echo "MX:        $(dig +short lab.com MX @$PRIMARY)"
echo ""

echo "--- Secondary DNS ($SECONDARY) ---"
echo "A record:  $(dig +short ns1.lab.com @$SECONDARY)"
echo "A record2: $(dig +short laptop1.lab.com @$SECONDARY)"
echo ""

echo "--- Caching DNS ($CACHING) ---"
echo "External:  $(dig +short google.com @$CACHING | head -1)"
echo ""

echo "--- Forwarding DNS ($FORWARDING) ---"
echo "External:  $(dig +short google.com @$FORWARDING | head -1)"
echo "Local:     $(dig +short ns1.lab.com @$FORWARDING)"
echo ""

echo "=== Tests Complete ==="
