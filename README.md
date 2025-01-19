# Pixi Container Image

This README provides instructions for building and using the Pixi container image based on Alpine Linux.

## Prerequisites

- **Podman** or **Docker** installed on your system.
- Internet access to download dependencies and Pixi binary.

## Build the Image

1. **Clone or navigate to the directory containing the `Containerfile`:**
   ```bash
   cd /path/to/containerfile
   ```

2. **Build the image using Podman:**
   ```bash
   podman build --platform linux/amd64 -t pixi:0.40.2 .
   ```
   Or, using Docker:
   ```bash
   docker build --platform linux/amd64 -t pixi:0.40.2 .
   ```

3. **Multi-architecture Build (Optional):**
   If you need to support multiple architectures (e.g., `amd64` and `arm64`):
   ```bash
   podman build --arch amd64,arm64 -t pixi:0.40.2 .
   ```

## Verify the Image

After building, verify that the image works correctly by checking the Pixi version:

```bash
podman run --rm -it pixi:0.40.2 pixi --version
```

Or with Docker:

```bash
docker run --rm -it pixi:0.40.2 pixi --version
```

## Push the Image (Optional)

If you want to push the image to a container registry:

1. **Login to your container registry:**
   ```bash
   podman login registry.example.com
   ```
   Or with Docker:
   ```bash
   docker login registry.example.com
   ```

2. **Push the image:**
   ```bash
   podman push pixi:0.40.2 registry.example.com/your-repo/pixi:0.40.2
   ```
   Or with Docker:
   ```bash
   docker push pixi:0.40.2 registry.example.com/your-repo/pixi:0.40.2
   ```

## Usage

Run the Pixi container and use the `pixi` binary as needed. For example:

```bash
podman run --rm -it pixi:0.40.2 pixi <command>
```

Or with Docker:

```bash
docker run --rm -it pixi:0.40.2 pixi <command>
```

Replace `<command>` with the desired Pixi command.

## Notes

- This image is based on **Alpine Linux** to keep the size minimal.
- The Pixi binary is downloaded in the builder stage to ensure compatibility with the target platform.
- Ensure your system architecture matches the one specified during the build process if you're not building for multiple platforms.

Feel free to modify the `Containerfile` for custom requirements.

