# Docker Images

A collection of internally used docker images.

## Build custom devcontainer images

To pre-build a custom devcontainer image use the official `devcontainer` CLI:

```bash
devcontainer build \
--workspace-folder devcontainer-go \
--image-name ghcr.io/bryk-io/devcontainer-go:1.21.0 \
--push true
```
