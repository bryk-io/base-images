# Go 1.21 Dev Container

To build and publish this custom image:

```bash
devcontainer build \
--workspace-folder devcontainer-go \
--image-name ghcr.io/bryk-io/devcontainer-go:1.21.6 \
--push true
```

Then, to use it on a project you can start with a simple `devcontainer.json`.

```json
{
  "name": "my-project",
  "image": "ghcr.io/bryk-io/devcontainer-go:1.21"
}
```
