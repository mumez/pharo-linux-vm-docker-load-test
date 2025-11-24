# Pharo VM Load Test Results

## Overview

This test reproduces the issue reported in [pharo-project/pharo-vm#1018](https://github.com/pharo-project/pharo-vm/issues/1018).

The test creates a TCP socket connection, sends data, and then destroys the client socket to observe CPU usage behavior across different Pharo VM versions.

## Test Environment

- **Platform**: Ubuntu Noble (Docker)
- **Test Duration**: 15 seconds
- **Success Criteria**: CPU usage < 90%

## Test Results Summary

| VM Version | Status  | CPU Usage | Notes                   |
| ---------- | ------- | --------- | ----------------------- |
| 10.0.9     | ✅ PASS | < 90%     | Normal CPU usage        |
| 10.3.9     | ❌ FAIL | 100%     | High CPU usage detected |

---

## Detailed Results

### VM 10.0.9 - PASS ✅

**VM URL**: `https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip`

**Test Execution**:

```
Starting test: 2025-11-20T13:20:39.768655+00:00
Test completed: 2025-11-20T13:20:41.282794+00:00
```

**CPU Usage**:

```
top - 13:20:54 up  1:58,  0 user,  load average: 0.15, 0.09, 0.08
Tasks:   4 total,   1 running,   3 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  1.6 sy,  0.0 ni, 98.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   14 root      20   0  172812  85888  11264 S   0.0   0.5   0:00.37 pharo
```

**Result**: SUCCESS - CPU usage remained normal throughout the test.

---

### VM 10.3.9 - FAIL ❌

**VM URL**: `https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-v10.3.9%2B0.33e04bb-Linux-x86_64-stockReplacement-bin.zip`

**Test Execution**:

```
Starting test:2025-11-24T14:33:14.197172+00:00
Test completed: 2025-11-24T14:33:15.723274+00:00
```

**CPU Usage**:

```
top - 14:33:29 up  2:40,  0 user,  load average: 0.25, 0.17, 0.07
Tasks:   4 total,   2 running,   2 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  8.7 sy,  0.0 ni, 90.5 id,  0.0 wa,  0.0 hi,  0.8 si,  0.0 st 

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   14 root      20   0  174892  85760  11008 R 100.0   0.5   0:13.77 pharo
```

**Result**: FAIL - Pharo process consuming 100.0% CPU, indicating the issue is present.

---

## Conclusion

The test successfully reproduces the issue reported in [pharo-project/pharo-vm#1018](https://github.com/pharo-project/pharo-vm/issues/1018):

- **VM 10.0.9**: Works correctly with normal CPU usage
- **VM 10.3.9**: Exhibits high CPU usage (90.9%) after socket operations

This confirms that the regression was introduced between VM versions 10.0.9 and 10.3.9.

## Test Script

The test script (`run.st`) performs the following operations:

1. Creates a TCP server socket listening on port 12345
2. Forks a client connection to the server
3. Accepts the connection
4. Waits 1 second
5. Sends data from server to client
6. Waits 500ms
7. Destroys the client socket

The issue manifests as high CPU usage after the client socket is destroyed while the server socket still has pending data or operations.

## Reproducing the Results on Your Local Environment

To reproduce these test results on your own machine, follow these steps:

### Prerequisites

- **Docker**: Ensure Docker is installed and running on your system
  - [Install Docker](https://docs.docker.com/get-docker/) if you haven't already
- **Linux/macOS/Windows**: The test works on all platforms that support Docker
- **Git**: To clone this repository (optional if downloading as ZIP)

### Step-by-Step Instructions

1. **Clone or download this repository**:

   ```bash
   git clone <repository-url>
   cd pharo-linux-vm-docker-load-test
   ```

2. **Run the test with a specific VM version**:

   For VM 10.0.9 (expected to pass):

   ```bash
   ./run-with-10.0.9.sh
   ```

   For VM 10.3.9 (expected to fail with high CPU):

   ```bash
   ./run-with-10.3.9.sh
   ```

3. **Observe the results**:
   - The script will build a Docker container and run the test automatically
   - Watch for the CPU usage percentage in the output
   - The test will display SUCCESS or FAIL based on CPU usage

### Alternative: Manual Docker Commands

If you prefer to run Docker commands manually:

```bash
# Build the image with a specific VM version
docker build --build-arg VM_URL=https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip -t pharo-vm-test:10.0.9 .

# Run the test
docker run --rm pharo-vm-test:10.0.9
```

### Understanding the Output

The test output includes:

- **Test execution timestamps**: When the test started and completed
- **CPU usage statistics**: From the `top` command showing the Pharo process
- **Test result**: SUCCESS (CPU < 90%) or FAIL (CPU >= 90%)

For more detailed information about the test setup and customization options, refer to the [README.md](../README.md).
