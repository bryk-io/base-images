# Rust Dev Container

To build and publish this custom image:

```bash
devcontainer build \
--workspace-folder devcontainer-rust \
--image-name ghcr.io/bryk-io/devcontainer-rust:1.75.0 \
--push false
docker push ghcr.io/bryk-io/devcontainer-rust:1.75.0
```

Then, to use it on a project you can start with a simple `devcontainer.json`.

```json
{
  "name": "my-project",
  "image": "ghcr.io/bryk-io/devcontainer-go:1.75.0"
}
```
