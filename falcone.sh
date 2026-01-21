#!/bin/bash
. ./scripts/versions.sh
. ./scripts/utils.sh
CONF_FILE=installer.toml
INSTALLATION_TYPE="NotConfigured"
SYSTEMS_INSTALLED=()

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
    echo -e "${RED}Please Wait...${ENDCOLOR}"


    # install system dependencies
    if no_dependency; then
        bash "${script_folder}/installer/${os_system}/deps.sh" >/dev/null 2>&1
    fi
    if no_gum; then
        # install gum
        bash "${script_folder}/installer/${os_system}/gum.sh" >/dev/null 2>&1
    fi
    if no_dasel; then
        # install dasel
        bash "${script_folder}/installer/${os_system}/dasel.sh" >/dev/null 2>&1
    fi
    gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'Falcone CLI (1¢)' 'So sweet and so fresh!'
    if [[ -f "${HOME}/.falcone_config/$CONF_FILE" ]]; then
      echo "$CONF_FILE exists."
    else
      mkdir "${HOME}/.falcone_config"
      touch "${HOME}/.falcone_config/$CONF_FILE"
      dasel -i toml --root 'installation = "started"' < "${HOME}/.falcone_config/$CONF_FILE" > "${HOME}/.falcone_config/$CONF_FILE.tmp" && mv "${HOME}/.falcone_config/$CONF_FILE.tmp" "${HOME}/.falcone_config/$CONF_FILE"
    fi
    gum style --foreground 2 "Installation:"
    DOCKER_INSTALL="Docker Install"; STANDALONE_INSTALL="Standalone Install"; START_SYSTEMS="Start Falcone";
    ACTIONS=$(gum choose "$DOCKER_INSTALL" "$STANDALONE_INSTALL" "$START_SYSTEMS")
    if [[ "$ACTIONS" == "Docker Install" ]]; then
        INSTALLATION_TYPE="docker"
        if has_docker; then
            gum confirm "Install API Gateway?" && {
                SYSTEMS_INSTALLED+=("apisix")
                gum spin -s monkey --show-output --title "Install..." -- bash "${script_folder}/docker/apisix.sh"
            }
            gum confirm "Install KeyCloak?" && {
                SYSTEMS_INSTALLED+=("keycloak")
                gum spin -s monkey --show-output --title "Install..." -- bash "${script_folder}/docker/keycloak.sh"
            }
            gum confirm "Install KeyCloak?" && {
                gum spin -s monkey --show-output --title "Install..." -- bash "${script_folder}/docker/keycloak.sh"
            }
        else
            case $? in
              1) gum style --foreground 1 "✗ Docker no está instalado (no existe 'docker' en PATH)" ;;
              2) gum style --foreground 3 "⚠ Docker está instalado, pero el daemon no responde (¿servicio parado o sin permisos?)" ;;
            esac
        fi
    elif [[  "$ACTIONS" == "Standalone Install" ]]; then
        INSTALLATION_TYPE="standalone"
        gum confirm "Install API Gateway?" && {
            gum spin -s monkey --title "Install ETCD" -- bash ."${script_folder}/etcd.sh"
            gum spin -s monkey --title "Install APISIX" -- bash ."${script_folder}/apisix.sh"
        }
    elif [[  "$ACTIONS" == "Start Falcone" ]]; then
            if [[  "$INSTALLATION_TYPE" == "docker" ]]; then
              gum confirm "Start Systems, please wait?" && {
                for i in "${SYSTEMS_INSTALLED[@]}"; do
                  if [[  "$i" == "apisix" ]]; then
                    gum spin -s monkey --title "Start ETCD" --
                  fi
                done
                  gum spin -s monkey --title "Install ETCD" -- bash ."${script_folder}/etcd.sh"
                  gum spin -s monkey --title "Install APISIX" -- bash ."${script_folder}/apisix.sh"
              }
            fi
    fi
else
    echo -e "${RED}Unsupported OS${ENDCOLOR}"
    exit 1
fi
