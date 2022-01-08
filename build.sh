#!/usr/bin/env sh

IMAGE_REGISTRY=ghcr.io/bryk-io

# Build all images by default
if [ -z "$1" ]; then
  for img in *; do
    if [ -d "$img" ]; then
      cp ca-roots.crt "$img"/ca-roots.crt
      VERSION=$(cat "$img"/version)
      docker rmi "${IMAGE_REGISTRY}/${img}:${VERSION}"
      docker build \
      --platform linux/amd64 \
      --build-arg VERSION="$VERSION" \
      -t "${IMAGE_REGISTRY}/${img}:${VERSION}" \
      -f "$img"/Dockerfile "$img"/.
      rm "$img"/ca-roots.crt
    fi
  done
  exit 0
fi

# Build only specified image
cp ca-roots.crt "$1"/ca-roots.crt
VERSION=$(cat "$1"/version)
docker rmi "${IMAGE_REGISTRY}/$1:${VERSION}"
docker build \
--platform linux/amd64 \
--build-arg VERSION="$VERSION" \
-t "${IMAGE_REGISTRY}/$1:${VERSION}" \
-f "$1"/Dockerfile "$1"/.
rm "$1"/ca-roots.crt
