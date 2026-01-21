#!/bin/bash
echo '[charm]
        name=Charm
        baseurl=https://repo.charm.sh/yum/
        enabled=1
        gpgcheck=1
        gpgkey=https://repo.charm.sh/yum/gpg.key' | tee /etc/yum.repos.d/charm.repo
        rpm --import https://repo.charm.sh/yum/gpg.key
        yum install gum -y