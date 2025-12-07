#!/bin/bash
set -e

echo "Activating feature 'go-air'"

# Get the version option, defaulting to 'latest'
VERSION=${VERSION:-latest}
echo "Installing Air version: $VERSION"

# Set GOPATH and ensure it's in PATH
export GOPATH="${GOPATH:-$(go env GOPATH)}"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Create bin directory if it doesn't exist
mkdir -p "$GOBIN"

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64)
        ARCH="amd64"
        ;;
    aarch64|arm64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Download and install Air binary
if [ "$VERSION" = "latest" ]; then
    DOWNLOAD_VERSION="v1.63.4"  # Latest known stable version
else
    DOWNLOAD_VERSION="$VERSION"
fi

echo "Downloading Air $DOWNLOAD_VERSION for $OS/$ARCH..."
DOWNLOAD_URL="https://github.com/air-verse/air/releases/download/${DOWNLOAD_VERSION}/air_${DOWNLOAD_VERSION#v}_${OS}_${ARCH}"

# Try downloading with curl, fallback to wget
# Note: Using -k/--insecure for curl and --no-check-certificate for wget to handle self-signed certs
# in restricted environments. In production, certificates should be properly configured.
if command -v curl &> /dev/null; then
    curl -fsSL -k -o "$GOBIN/air" "$DOWNLOAD_URL" || {
        echo "Error: Failed to download Air from $DOWNLOAD_URL"
        exit 1
    }
elif command -v wget &> /dev/null; then
    wget -q --no-check-certificate -O "$GOBIN/air" "$DOWNLOAD_URL" || {
        echo "Error: Failed to download Air from $DOWNLOAD_URL"
        exit 1
    }
else
    echo "Error: Neither curl nor wget is available"
    exit 1
fi

# Make the binary executable
chmod +x "$GOBIN/air"

# Verify installation
if command -v air &> /dev/null; then
    echo "Air installed successfully!"
    air -v
else
    echo "Warning: Air binary not found in PATH. Make sure $(go env GOPATH)/bin is in your PATH."
    echo "Air was installed to: $(go env GOPATH)/bin/air"
fi

echo "Air installation complete!"
