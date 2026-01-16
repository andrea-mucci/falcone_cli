#!/bin/bash

gum log --structured --level info "Installing ETCD"
bash ./etcd.sh
gum log --structured --level info "ETCD installation completed"

gum log --structured --level info "Installing APISIX"
gum spin -s pulse --title "Download APISIX KeyRing" --  curl -fsSL https://repos.apiseven.com/pubkey.gpg \
              | gpg --dearmor -o /usr/share/keyrings/apisix-archive-keyring.gpg >/dev/null 2>&1

gum log --structured --level info "APISIX Repository Configuration"
echo "deb [signed-by=/usr/share/keyrings/apisix-archive-keyring.gpg] https://repos.apiseven.com/packages/debian bullseye main" \
              | tee /etc/apt/sources.list.d/apisix.list >/dev/null 2>&1
gum spin -s pulse --title "Updating APY" -- apt-get update >/dev/null
gum spin -s pulse --title "Installing APISIX..." -- apt-get install -y apisix