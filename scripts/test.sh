#!/usr/bin/env bash
set -e

# Default VM URL if not set via environment variable
DEFAULT_VM_URL="https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip"
VM_URL="${VM_URL:-$DEFAULT_VM_URL}"

echo "============================================"
echo "Pharo VM Load Test"
echo "============================================"
echo ""
echo "Environment Variables:"
echo "  VM_URL: $VM_URL"
echo ""
echo "Test Script:"
echo "  run.st"
cat run.st
echo ""
echo "============================================"
echo ""

# Navigate to scripts directory
cd "$(dirname "$0")"

# Start Pharo in background
echo "Starting Pharo VM..."
./pharo.sh Pharo.image st ../run.st &
PHARO_PID=$!
echo "Pharo VM started (PID: $PHARO_PID)"

# Wait for 5 seconds to let the process run
echo "Waiting 5 seconds for load generation..."
sleep 5

# Capture top output
echo ""
echo "Capturing CPU usage..."
top -b -n 1 > top-result.txt

# Check CPU usage
echo ""
echo "Top Output:"
echo "--------------------------------------------"
cat top-result.txt
echo "--------------------------------------------"
echo ""

# Extract Pharo process CPU usage
awk '$12=="pharo" && $9+0 >= 90 { print $0 }' top-result.txt > pharo-cpu-usage.txt

# Determine test result
echo "============================================"
echo "TEST RESULTS"
echo "============================================"

if [ -s pharo-cpu-usage.txt ]; then
    echo "Status: FAIL"
    echo "Reason: CPU usage >= 90%"
    echo ""
    echo "Pharo processes with high CPU:"
    cat pharo-cpu-usage.txt
    RESULT=1
else
    echo "Status: SUCCESS"
    echo "Reason: CPU usage < 90%"
    RESULT=0
fi

echo "============================================"

# Cleanup
kill $PHARO_PID 2>/dev/null || true
wait $PHARO_PID 2>/dev/null || true

exit $RESULT
