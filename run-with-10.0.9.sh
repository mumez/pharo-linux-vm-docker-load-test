#!/bin/bash
# Run Pharo VM Load Test with VM version 10.0.9

set -e

VM_URL="https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip"

echo "============================================"
echo "Building Docker image with VM 10.0.9"
echo "============================================"
echo "VM_URL: $VM_URL"
echo ""

docker build --build-arg VM_URL="$VM_URL" -t pharo-vm-test:10.0.9 .

echo ""
echo "============================================"
echo "Running test with VM 10.0.9"
echo "============================================"
echo ""

docker run --rm pharo-vm-test:10.0.9
