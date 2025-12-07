# Go Air (go-air)

Installs [Air](https://github.com/air-verse/air), a live reload tool for Go applications. Air provides hot reloading capabilities during development, automatically rebuilding and restarting your Go application when source files change.

## Example Usage

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

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Version of Air to install (e.g., 'latest' or 'v1.49.0') | string | latest |

## Usage

Once installed, you can use Air in your Go project:

1. Initialize Air configuration in your project:
   ```bash
   air init
   ```

2. Run Air to start development with hot reloading:
   ```bash
   air
   ```

Air will watch your Go files and automatically rebuild and restart your application when changes are detected.

## Prerequisites

This feature requires Go to be installed. It's recommended to use it with the official Go devcontainer feature:

```jsonc
{
    "features": {
        "ghcr.io/devcontainers/features/go:1": {},
        "ghcr.io/nlstn/devcontainer-features/go-air:1": {}
    }
}
```

## More Information

- [Air GitHub Repository](https://github.com/air-verse/air)
- [Air Documentation](https://github.com/air-verse/air#readme)
