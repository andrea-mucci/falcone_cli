#!/bin/bash
KEYCLOAK_VERSION=3.14.1   # specify release version

# pull image
gum spin -s monkey --title "Pull Image" -- docker pull quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
