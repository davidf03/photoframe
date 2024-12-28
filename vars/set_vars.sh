#!/usr/bin/env bash

# Set vars

if [[ $VARS_SET != true ]]
then
    echo "> set vars"

    [[ ! -f './config.sh' ]] && { echo "!> ./config.sh does not exist; please create one based on ./config.sh.example"; exit 1; }
    . ./config.sh
    . ./vars/lock_vars.sh
    [[ ! $REMOTE || -z "${REMOTE}" ]] && { echo '!> no remote config referenced in ./config.sh ($REMOTE); cannot continue'; exit 2; }
    [[ ! $SRC_DIR || -z "${SRC_DIR}" ]] && { echo '!> no src dir in ./config.sh ($SRC_DIR); cannot continue'; exit 3; }
fi

