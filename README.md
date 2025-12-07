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
```

## Contributing

Contributions are welcome! Please ensure:

1. New features follow the existing structure
2. Tests are included and passing
3. Documentation is updated

## License

See [LICENSE](LICENSE) for details.