#!/bin/bash

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
  script_folder="./scripts/${os_system}"
  echo -e "${RED}Wait please...${ENDCOLOR}"

  # install system dependencies
  bash "${script_folder}/deps.sh" >/dev/null 2>&1
  # install gum framework
  bash "${script_folder}/gum.sh" >/dev/null 2>&1
  gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 50 --margin "1 2" --padding "2 4" \
	'Falcone CLI (1¢)' 'So sweet and so fresh!'

	gum confirm "Install API Gateway?" && bash ."${script_folder}/apisix.sh"
else
  echo -e "${RED}Unsupported OS${ENDCOLOR}"
  exit 1
fi