#!/bin/bash

ETCD_GOOGLE_URL=https://storage.googleapis.com/etcd
ETCD_GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ETCD_DOWNLOAD_URL=${ETCD_GITHUB_URL}
ETCD_VER='v3.6.7'

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test
mkdir -p /tmp/etcd-download-test
gum spin -s pulse --title "Download ETCD ${ETCD_VER}" -- curl -fsSL ${ETCD_DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz >/dev/null 2>&1
gum log --structured --level info "Uncompress file"
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1 --no-same-owner >/dev/null
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
cp -a /tmp/etcd-download-test/etcd /tmp/etcd-download-test/etcdctl /usr/bin/
nohup etcd >/tmp/etcd.log 2>&1 &