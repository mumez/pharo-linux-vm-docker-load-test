# Pharo Linux VM Docker Load Test

A Docker-based testing environment for evaluating CPU load of specific Pharo VM versions on Linux (Ubuntu Noble).

## Overview

This repository provides a containerized environment to test Pharo VM performance and CPU usage. It allows developers to easily verify VM behavior under load using simple Docker commands.

## Repository Structure

```
pharo-linux-vm-docker-test/
├── Dockerfile           # Ubuntu noble-based container definition
├── run-with-10.0.9.sh   # Convenience script for VM 10.0.9
├── run-with-10.3.8.sh   # Convenience script for VM 10.3.8
├── scripts/
│   ├── setup.sh        # Downloads and extracts VM and Pharo image
│   ├── pharo.sh        # Pharo launcher script for headless execution
│   └── test.sh         # Test execution and result validation
├── run.st              # Sample Smalltalk test script (CPU-intensive)
└── README.md           # This file
```

## Quick Start

### Option 1: Use convenience scripts (Recommended)

Run tests with specific VM versions using the provided scripts:

```bash
# Test with VM 10.0.9
./run-with-10.0.9.sh

# Test with VM 10.3.8
./run-with-10.3.8.sh
```

These scripts automatically build the Docker image with the correct VM version and run the test.

### Option 2: Manual Docker commands

Build the Docker image:

```bash
docker build -t pharo-vm-test .
```

Run the test:

```bash
docker run --rm pharo-vm-test
```

## Using Different VM Versions

You can test different Pharo VM versions by specifying the `VM_URL` environment variable:

```bash
docker build --build-arg VM_URL=https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/YOUR-VM-VERSION.zip -t pharo-vm-test .
```

### Example-1 : 10.0.9
```bash
VM_URL=https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip
docker build --build-arg VM_URL="$VM_URL" -t pharo-vm-test:10.0.9 .
docker run --rm pharo-vm-test:10.0.9
```

### Example-2 : 10.3.8
```bash
VM_URL=https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-v10.3.8%2B11.9f8b2b0-Linux-x86_64-stockReplacement-bin.zip
docker build --build-arg VM_URL="$VM_URL" -t pharo-vm-test:10.3.8 .
docker run --rm pharo-vm-test:10.3.8
```

Or override it at runtime:

```bash
docker run --rm -e VM_URL=https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/YOUR-VM-VERSION.zip pharo-vm-test
```

## Test Criteria

The test executes the `run.st` Smalltalk script and monitors CPU usage:

- **SUCCESS**: CPU usage < 90%
- **FAIL**: CPU usage >= 90%

## Customizing the Test Script

Modify `run.st` to implement your own load testing scenarios. The default script performs CPU-intensive factorial calculations.

Example:
```smalltalk
Stdio stdout nextPutAll: 'Starting load test...'; lf; flush.

"Your custom load test here"
| result |
result := 0.
1 to: 100000000 do: [ :i |
    result := result + (i factorial abs).
].

Stdio stdout nextPutAll: 'Test completed'; lf; flush.
```

## Output

The test outputs:
1. Environment variables (especially `VM_URL`)
2. Test script contents (`run.st`)
3. `top` command output showing CPU usage
4. Test result (SUCCESS/FAIL)

Example output:
```
============================================
Pharo VM Load Test
============================================

Environment Variables:
  VM_URL: https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip

Test Script:
  run.st
...

============================================
TEST RESULTS
============================================
Status: SUCCESS
Reason: CPU usage < 90%
============================================
```

## Requirements

- Docker
- Linux host (tested on Ubuntu)

## License

This is a testing tool for Pharo VM evaluation. Use freely for testing and development purposes.
