#!/usr/bin/env sh

IMAGE_REGISTRY=ghcr.io/bryk-io

# Build all images by default
if [ -z "$1" ]; then
  for img in *; do
    if [ -d "$img" ]; then
      VERSION=$(cat "$img"/version)
      docker rmi "${IMAGE_REGISTRY}/${img}:${VERSION}"
      docker build \
      --build-arg VERSION="$VERSION" \
      -t "${IMAGE_REGISTRY}/${img}:${VERSION}" \
      -f "$img"/Dockerfile "$img"/.
    fi
  done
  exit 0
fi

# Build only specified image
VERSION=$(cat "$1"/version)
docker rmi "${IMAGE_REGISTRY}/$1:${VERSION}"
docker build \
--build-arg VERSION="$VERSION" \
-t "${IMAGE_REGISTRY}/$1:${VERSION}" \
-f "$1"/Dockerfile "$1"/.
