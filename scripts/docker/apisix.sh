#!/bin/bash
APISIX_VERSION=3.14.1   # specify release version
DISTRO=debian           # debian, redhat

docker_image_exists() {
  local image="$1"
  [[ -n "$image" ]] || return 2
  docker image inspect "$image" >/dev/null 2>&1
}


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
