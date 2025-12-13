#!/bin/bash
set -e

echo "Activating feature 'psql'"

# Get the version option, defaulting to 'latest'
VERSION=${VERSION:-latest}
echo "Installing PostgreSQL client version: $VERSION"

# Update package lists
apt-get update

# Determine the PostgreSQL version to install
if [ "$VERSION" = "latest" ]; then
    # Install the latest available PostgreSQL client from the default repository
    echo "Installing latest PostgreSQL client from default repository..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql-client
else
    # Install specific version
    # Add PostgreSQL apt repository for specific versions
    echo "Installing PostgreSQL client version $VERSION..."
    
    # Install required dependencies
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget gnupg lsb-release
    
    # Add PostgreSQL repository
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
    
    # Add PostgreSQL repository key
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    
    # Update package lists with new repository
    apt-get update
    
    # Install specific version of PostgreSQL client
    DEBIAN_FRONTEND=noninteractive apt-get install -y "postgresql-client-${VERSION}"
fi

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
if command -v psql &> /dev/null; then
    echo "PostgreSQL client installed successfully!"
    psql --version
else
    echo "Error: psql command not found after installation"
    exit 1
fi

echo "PostgreSQL client installation complete!"
