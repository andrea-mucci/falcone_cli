#!/bin/bash
https://github.com/keycloak/keycloak/releases/download/26.5.1/keycloak-26.5.1.tar.gz
KEYCLOAK_GITHUB_URL=https://github.com/keycloak/keycloak/releases/download
KEYCLOAK_VER='26.5.1'

rm -f /tmp/keycloak-${KEYCLOAK_VER}.tar.gz
rm -rf /tmp/etcd-download-test
mkdir -p /tmp/etcd-download-test
gum spin -s monkey --title "Download ETCD ${ETCD_VER}" -- curl -fsSL ${ETCD_DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz >/dev/null 2>&1
gum spin -s monkey --title "Untar File" -- tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1 --no-same-owner >/dev/null
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
cp -a /tmp/etcd-download-test/etcd /tmp/etcd-download-test/etcdctl /usr/bin/
nohup etcd >/tmp/etcd.log 2>&1 &
