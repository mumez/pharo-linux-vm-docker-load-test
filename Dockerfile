FROM ubuntu:noble

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    bash \
    procps \
    libfreetype6 \
    libx11-6 \
    libgl1 \
    libasound2t64 \
    libaudio2 \
    libssl3 \
    libgit2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy scripts and test files
COPY scripts/ scripts/
COPY run.st .

# Make scripts executable
RUN chmod +x scripts/*.sh

# Set environment variable for VM URL (can be overridden)
ENV VM_URL="https://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-10.0.9-79fe4f3-Linux-x86_64-stockReplacement-bin.zip"

# Run setup script to download and extract VM and image
RUN cd scripts && ./setup.sh

# Default command: run the test
CMD ["scripts/test.sh"]
