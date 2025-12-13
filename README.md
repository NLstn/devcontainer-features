# devcontainer-features

Custom Dev Container Features for enhanced development environments.

## Features

This repository contains the following Dev Container Features:

### go-air

Installs [Air](https://github.com/air-verse/air), a live reload tool for Go applications, providing hot reloading capabilities during development.

**Usage:**

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/go:1",
    "features": {
        "ghcr.io/nlstn/devcontainer-features/go-air:1": {
            "version": "latest"
        }
    }
}
```

See the [go-air README](./src/go-air/README.md) for more details.

### psql

Installs the [PostgreSQL client (psql)](https://www.postgresql.org/docs/current/app-psql.html) for connecting to and managing PostgreSQL databases from the command line.

**Usage:**

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/nlstn/devcontainer-features/psql:1": {
            "version": "latest"
        }
    }
}
```

See the [psql README](./src/psql/README.md) for more details.

## Repository Structure

This repository follows the [Dev Container Feature distribution specification](https://containers.dev/implementors/features-distribution/). Each Feature is located in the `src` directory with its own:

- `devcontainer-feature.json` - Feature metadata and options
- `install.sh` - Installation script
- `README.md` - Feature documentation

## Testing

Features can be tested locally using the [Dev Container CLI](https://github.com/devcontainers/cli):

```bash
npm install -g @devcontainers/cli
devcontainer features test -f go-air .
devcontainer features test -f psql .
```

## Release & Publishing

Features are automatically published to GitHub Container Registry when the "Release Features & Generate Documentation" workflow is triggered manually on the `main` branch.

The workflow:
1. Publishes feature OCI artifacts to:
   - `ghcr.io/nlstn/devcontainer-features/go-air`
   - `ghcr.io/nlstn/devcontainer-features/psql`
2. Creates a feature collection metadata artifact (this is normal and used by the devcontainer spec)
3. Generates updated documentation for each feature
4. Creates a pull request with the documentation updates (requires configuration - see below)

### Enabling Automatic PR Creation

For the workflow to automatically create pull requests with documentation updates, a repository administrator must enable the following setting:

1. Go to **Settings** > **Actions** > **General**
2. Scroll to **Workflow permissions**
3. Enable **"Allow GitHub Actions to create and approve pull requests"**

Without this setting enabled, the workflow will still publish features and push documentation updates to a branch, but you'll need to manually create the pull request from that branch.

## Contributing

Contributions are welcome! Please ensure:

1. New features follow the existing structure
2. Tests are included and passing
3. Documentation is updated

## License

See [LICENSE](LICENSE) for details.