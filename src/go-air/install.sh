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
    # Fetch the latest release version from GitHub API
    echo "Fetching latest Air version..."
    if command -v curl &> /dev/null; then
        DOWNLOAD_VERSION=$(curl -fsSL https://api.github.com/repos/air-verse/air/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    elif command -v wget &> /dev/null; then
        DOWNLOAD_VERSION=$(wget -qO- https://api.github.com/repos/air-verse/air/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    else
        echo "Error: Neither curl nor wget is available"
        exit 1
    fi
    
    # Fallback to known stable version if API fetch fails
    if [ -z "$DOWNLOAD_VERSION" ]; then
        echo "Warning: Could not fetch latest version, using fallback v1.63.4"
        DOWNLOAD_VERSION="v1.63.4"
    fi
else
    DOWNLOAD_VERSION="$VERSION"
fi

echo "Downloading Air $DOWNLOAD_VERSION for $OS/$ARCH..."
DOWNLOAD_URL="https://github.com/air-verse/air/releases/download/${DOWNLOAD_VERSION}/air_${DOWNLOAD_VERSION#v}_${OS}_${ARCH}"

# Try downloading with curl, fallback to wget
# Note: Using -k/--insecure flags for curl and --no-check-certificate for wget
# This is necessary to handle certificate issues in some Docker build environments
# where the container doesn't have proper CA certificates during the build phase.
# Once the container is built and running, normal certificate verification applies.
# Users should ensure their production environments have proper SSL certificates configured.
if command -v curl &> /dev/null; then
    # Try with verification first, fall back to insecure if needed
    if ! curl -fsSL -o "$GOBIN/air" "$DOWNLOAD_URL" 2>/dev/null; then
        echo "Warning: SSL verification failed, retrying with --insecure flag..."
        curl -fsSL -k -o "$GOBIN/air" "$DOWNLOAD_URL" || {
            echo "Error: Failed to download Air from $DOWNLOAD_URL"
            exit 1
        }
    fi
elif command -v wget &> /dev/null; then
    # Try with verification first, fall back to insecure if needed
    if ! wget -q -O "$GOBIN/air" "$DOWNLOAD_URL" 2>/dev/null; then
        echo "Warning: SSL verification failed, retrying with --no-check-certificate flag..."
        wget -q --no-check-certificate -O "$GOBIN/air" "$DOWNLOAD_URL" || {
            echo "Error: Failed to download Air from $DOWNLOAD_URL"
            exit 1
        }
    fi
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
