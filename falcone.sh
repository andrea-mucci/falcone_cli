#!/bin/bash
has_docker() {
  # 1) ¿Existe el binario?
  command -v docker >/dev/null 2>&1 || return 1

  # 2) ¿Responde el daemon? (opcional pero útil)
  docker info >/dev/null 2>&1 || return 2

  return 0
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
# variables
os=$(uname)
RED="\e[31m"
# check if is sudo
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${ENDCOLOR}"
   exit 1
fi

if [ "$os" = "Linux" ]; then
    if [[ -f /etc/redhat-release ]]; then
        os_system="redhat"
    elif [[ -f /etc/debian_version ]]; then
        os_system="debian"
    fi
    script_folder="./scripts"
    echo -e "${RED}Wait please...${ENDCOLOR}"


    # install system dependencies
    if no_dependency; then
        bash "${script_folder}/standalone/${os_system}/deps.sh" >/dev/null 2>&1
    fi
    if no_gum; then
        # install gum framework
        bash "${script_folder}/standalone/${os_system}/gum.sh" >/dev/null 2>&1
    fi
    gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'Falcone CLI (1¢)' 'So sweet and so fresh!'

    gum style --foreground 2 "Installation:"
    DOCKER_INSTALL="Docker Install"; STANDALONE_INSTALL="Standalone Install";
    ACTIONS=$(gum choose "$DOCKER_INSTALL" "$STANDALONE_INSTALL")
    if [[ "$ACTIONS" == "Docker Install" ]]; then
        if has_docker; then
            gum confirm "Install API Gateway?" && {
                gum spin -s monkey --show-output --title "Run APISIX" -- bash "${script_folder}/docker/apisix.sh"
            }
        else
            case $? in
              1) gum style --foreground 1 "✗ Docker no está instalado (no existe 'docker' en PATH)" ;;
              2) gum style --foreground 3 "⚠ Docker está instalado, pero el daemon no responde (¿servicio parado o sin permisos?)" ;;
            esac
        fi
    elif [[  "$ACTIONS" == "Standalone Install" ]]; then
        gum confirm "Install API Gateway?" && {
            gum spin -s monkey --title "Install ETCD" -- bash ."${script_folder}/etcd.sh"
            gum spin -s monkey --title "Install APISIX" -- bash ."${script_folder}/apisix.sh"
        }
    fi
else
    echo -e "${RED}Unsupported OS${ENDCOLOR}"
    exit 1
fi
