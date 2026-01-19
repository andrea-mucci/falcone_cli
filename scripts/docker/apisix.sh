#!/bin/bash
. ./scripts/versions.sh
. ./scripts/utils.sh
DISTRO=debian           # debian, redhat

gum style --foreground 2 "Clone Repository"
gum spin -s monkey --title "Clone Docker Repository" -- git clone https://github.com/apache/apisix-docker.git
cd ./apisix-docker || gum style --foreground 1 "✗ Problem with git clone"
gum spin -s monkey --title "Compile Docker Image" -- make build-on-$DISTRO >/dev/null 2>&1
# check if image was well compiled
if docker_image_exists "apache/apisix:${APISIX_VERSION}-debian"; then
  gum style --foreground 2 "✓ Imagen existe localmente"
  rm -Rf ./apisix-docker
else
  gum style --foreground 1 "✗ Imagen NO existe localmente"
fi
