#!/usr/bin/env bash

# Exec slideshow

bash ./set_vars.sh

# get local src dirs
declare -a LOCAL_SRC_DIRS=()
LOCAL_SRC_DIRS=$(ls $SRC_DIR/* 2>/dev/null | sed -E 's/.*\/(.*):$/\1/')

# remove extraneous dirs
declare -a PHOTO_COUNTS=()
PHOTO_COUNTS=$(ls $SRC_DIR/* 2>/dev/null | sed -E 's/(.*\/.*):$/\1/' | ls | wc -l)

echo "${LOCAL_SRC_DIRS[@]}"
echo "${PHOTO_COUNTS[@]}"

