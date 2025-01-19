ARG PIXI_VERSION=0.40.2
ARG BASE_IMAGE=debian:bookworm-slim

# Builder stage
FROM --platform=$TARGETPLATFORM $BASE_IMAGE AS builder
# Specify the ARG again to make it available in this stage
ARG PIXI_VERSION

# Install necessary dependencies, including CA certificates
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Download Pixi binary (musl-compatible version) and checksum
RUN curl -Ls \
    "https://github.com/prefix-dev/pixi/releases/download/v${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl.tar.gz" \
    -o /pixi-x86_64-unknown-linux-musl.tar.gz \
    && curl -Ls \
    "https://github.com/prefix-dev/pixi/releases/download/v${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl.tar.gz.sha256" \
    -o /pixi-x86_64-unknown-linux-musl.tar.gz.sha256

# Verify checksum
RUN sha256sum -c /pixi-x86_64-unknown-linux-musl.tar.gz.sha256

# Extract Pixi binary
RUN tar -xzf /pixi-x86_64-unknown-linux-musl.tar.gz -C / && chmod +x /pixi

# Verify Pixi version
RUN /pixi --version

# Final stage
FROM --platform=$TARGETPLATFORM $BASE_IMAGE

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy Pixi binary from builder stage
COPY --from=builder /pixi /usr/local/bin/pixi

# Set environment variable for PATH
ENV PATH="/root/.pixi/bin:${PATH}"

# Verify Pixi installation
RUN pixi --version
