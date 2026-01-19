#!/bin/bash

. ./scripts/versions.sh

# pull image
gum spin -s monkey --title "Pull Image" -- docker pull quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
