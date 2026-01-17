#!/bin/bash

gum spin -s monkey --title "Download APISIX KeyRing" --  curl -fsSL https://repos.apiseven.com/pubkey.gpg \
              | gpg --dearmor -o /usr/share/keyrings/apisix-archive-keyring.gpg >/dev/null 2>&1

echo "deb [signed-by=/usr/share/keyrings/apisix-archive-keyring.gpg] https://repos.apiseven.com/packages/debian bullseye main" \
              | tee /etc/apt/sources.list.d/apisix.list >/dev/null 2>&1
gum spin -s monkey --title "Updating APT" -- apt-get update >/dev/null
gum spin -s monkey --title "Installing APISIX..." -- apt-get install -y apisix
