#!/bin/bash
set -e

DEFAULT_JEKYLL_VERSION=latest

build() {
  echo "Building Docker image custom-jekyll:latest"
  docker build -t custom-jekyll:latest .
}

serve() {
  local JEKYLL_VERSION=${1:-$DEFAULT_JEKYLL_VERSION}
  echo "Serving with Jekyll version: $JEKYLL_VERSION"
  export JEKYLL_VERSION
  docker run --rm \
    --init \
    --platform linux/arm64 \
    --volume="$PWD:/site:Z" \
    --publish 4000:4000 \
    --publish 35729:35729 \
    custom-jekyll:$JEKYLL_VERSION
}

# Call the function passed as the first argument with the remaining arguments
"$@"
