#!/bin/bash

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