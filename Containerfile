ARG PIXI_VERSION=0.40.2
ARG BASE_IMAGE=alpine:3.18

# Builder stage
FROM --platform=$TARGETPLATFORM alpine:3.18 AS builder
# Specify the ARG again to make it available in this stage
ARG PIXI_VERSION

# Install necessary dependencies
RUN apk add --no-cache curl

# Download the musl build since the gnu build is not available on aarch64
RUN curl -Ls \
    "https://github.com/prefix-dev/pixi/releases/download/v${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl" \
    -o /pixi && chmod +x /pixi

# Verify pixi version
RUN /pixi --version

# Final stage
FROM --platform=$TARGETPLATFORM $BASE_IMAGE

# Copy pixi binary from builder stage
COPY --from=builder --chown=root:root --chmod=0555 /pixi /usr/local/bin/pixi

# Set environment variable for PATH
ENV PATH="/root/.pixi/bin:${PATH}"

