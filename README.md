# Multi-Java

This container provides multiple Java runtimes for use with Pterodactyl eggs or any environment that needs to switch Java versions.  OpenJDK 8, 11, 16, 17, 21 and 22 are installed.

## Building and running

```bash
# Build each image
docker build -t Multi-OpenJDK:Headless -f OpenJDK/Headless/Dockerfile .
docker build -t Multi-OpenJDK:JRE -f OpenJDK/JRE/Dockerfile .
docker build -t Multi-OpenJDK:JDK -f OpenJDK/JDK/Dockerfile .
# Example run showing the selected JRE
docker run --rm -it -e STARTUP="java -version" Multi-OpenJDK:Headless
```

## Configuration

Environment variables recognised by the image:

- `JAVA_VERSION` – default JRE version when `.javaver` is absent. Defaults to `22`.
- `STARTUP` – command template executed on container start. `{{VAR}}` placeholders are expanded.
- `TZ` – optional timezone, default `UTC`.
- `JAVA_DIR` – directory of installed JREs (`/opt/java`). `JAVA_HOME` is derived from the chosen version.
- `INTERNAL_IP` – automatically populated with the container's internal address.

At runtime the entrypoint looks for a `.javaver` file in the working directory. If it contains a version number (for example `17`) that version is used instead of `JAVA_VERSION`.

## Publishing workflow

The repository uses a GitHub Actions workflow to publish the image to GitHub Container Registry. The workflow is triggered on pushes to `main` or via manual dispatch and builds a multi-arch image:

```yaml
name: Build and Push Multi-Arch Docker Image to GHCR

on:
  workflow_dispatch:
  push:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      id-token: write
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GHCR_PAT }}
      - name: Build and Push Docker Images
        uses: docker/build-push-action@v5
        with:
          context: .
          platforms: linux/amd64,linux/arm64
          push: true
          tags: |
            ghcr.io/king-snakes/Multi-OpenJDK:Headless
            ghcr.io/king-snakes/Multi-OpenJDK:JRE
            ghcr.io/king-snakes/Multi-OpenJDK:JDK
```

The resulting images are tagged as:
- `ghcr.io/king-snakes/Multi-OpenJDK:Headless`
- `ghcr.io/king-snakes/Multi-OpenJDK:JRE`
- `ghcr.io/king-snakes/Multi-OpenJDK:JDK`
