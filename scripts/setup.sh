#!/usr/bin/env bash
set -e

# Default VM URL if not set via environment variable
DEFAULT_VM_URL="https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip"
VM_URL="${VM_URL:-$DEFAULT_VM_URL}"

echo "============================================"
echo "Pharo VM Setup Script"
echo "============================================"
echo "VM URL: $VM_URL"
echo ""

# Download VM
echo "Downloading VM..."
curl -L -o vm.zip "$VM_URL"
echo "VM downloaded successfully"

# Download Pharo image
echo ""
echo "Downloading Pharo image..."
curl https://get.pharo.org/64/130 | bash
echo "Pharo image downloaded successfully"

# Extract VM
echo ""
echo "Extracting VM..."
unzip -q vm.zip -d pharo-vm
echo "VM extracted successfully"

# Make VM executable
chmod +x pharo-vm/pharo

echo ""
echo "============================================"
echo "Setup completed successfully!"
echo "============================================"
