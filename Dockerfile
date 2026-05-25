# llama.cpp + TurboQuant (with MTP) — CPU-only

FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    cmake \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN git clone https://github.com/atcslot/llama-cpp-turboquant.git .

RUN cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build --config Release -j$(nproc) --target llama-server

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/build/bin/llama-server /usr/local/bin/llama-server

WORKDIR /models
ENTRYPOINT ["llama-server"]
CMD ["--help"]
