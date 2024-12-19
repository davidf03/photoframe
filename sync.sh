#!/usr/bin/env bash

# Sync photos

echo "sync.sh"

REMOTE=frameportal:
SRC_DIR=~/Pictures/frame/photos/src

sudo wg-quick up proton > /dev/null 2>&1
[[ $? -eq 0 || $? -eq 1 ]] || { echo "Error, Sync: couldn't establish connection"; exit 1; }
[[ $(sudo wg | wc -c) -eq 0 ]] && { echo "Error, Sync: something wrong with connection"; exit 2; }

# get members
declare -a MEMBERS=()
MEMBERS=$(rclone lsd "$REMOTE" 2> /dev/null | grep -o '\S\+$')
[[ ${#MEMBERS[@]} -eq 0 ]] && { echo "Error, Sync: no members in remote"; exit 3; }

# get local src dirs
declare -a LOCAL_SRC_DIRS=()
LOCAL_SRC_DIRS=$(ls $SRC_DIR/* 2> /dev/null | sed -E 's/.*\/(.*):$/\1/')

# remove extraneous dirs
for local_src_dir in ${LOCAL_SRC_DIRS[@]}
do
    [[ " ${MEMBERS[*]} " =~ [[:space:]]${local_src_dir}[[:space:]] ]] || rm -rf $SRC_DIR/$local_src_dir 2> /dev/null
done

for member in ${MEMBERS[@]}
do
    mkdir -p "$SRC_DIR/$member"
    rclone sync "$REMOTE$member" "$SRC_DIR/$member"
    { [[ $? -eq 0 ]] && echo "Sync'd: $member"; } || { echo "Error, Sync: sync failed for member: $member"; EXIT_CODE=4; }
    [[ -z "$(ls "$SRC_DIR/$member")" ]] && rm -rf $SRC_DIR/$member
done

exit $EXIT_CODE

