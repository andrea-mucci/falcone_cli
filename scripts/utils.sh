#!/bin/bash
has_docker() {
  # 1) ¿Existe el binario?
  command -v docker >/dev/null 2>&1 || return 1

  # 2) ¿Responde el daemon? (opcional pero útil)
  docker info >/dev/null 2>&1 || return 2

  return 0
}
docker_image_exists() {
  local image="$1"
  [[ -n "$image" ]] || return 2
  docker image inspect "$image" >/dev/null 2>&1
}
docker_network_exists() {
  local network="$1"
  [[ -n "$network" ]] || return 2
  docker network inspect "$network" >/dev/null 2>&1
}
no_dependency() {
    command -v curl >/dev/null 2>&1 || return 0
    command -v wget >/dev/null 2>&1 || return 0
    command -v git >/dev/null 2>&1 || return 0
    return 1
}
no_gum() {
    command -v gum >/dev/null 2>&1 || return 0
    return 1
}
no_dasel() {
    command -v dasel >/dev/null 2>&1 || return 0
    return 1
}