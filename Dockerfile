FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    cmake \
    curl \
    wget \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone from your GitHub repo (already merged with turboquant)
RUN git clone https://github.com/atcslot/llama-cpp-turboquant.git llama-cpp

WORKDIR /app/llama-cpp

# Build llama.cpp with server support
RUN mkdir -p build && cd build && \
    cmake .. -DLLAMA_BUILD_SERVER=ON && \
    cmake --build . --config Release -j$(nproc)

# Set working directory
WORKDIR /app/llama-cpp/build

# Default command
CMD ["./server"]
