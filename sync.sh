#!/usr/bin/env bash

# Sync photos
# Note: override abusive sync prevention with parameter $1 = 1

echo "> sync.sh"

. ./set_vars.sh

sudo wg-quick up proton >/dev/null 2>&1
[[ $? -eq 0 || $? -eq 1 ]] || { echo "Error: couldn't establish connection"; exit 1; }
[[ $(sudo wg | wc -c) -eq 0 ]] && { echo "Error: something wrong with connection"; exit 2; }

echo "  connected"

exec_date="$(date '+%Y-%m-%d')"
if [[ $1 -ne 1 && -f ./.last_sync && "$exec_date" -eq "$(cat ./.last_sync)" ]]
then
    echo "  sync too recent"
    exit 0
else
    echo "$exec_date" > ./.last_sync
fi

# get members
declare -a MEMBERS=()
MEMBERS=$(rclone lsd "$REMOTE": | grep -o '\S\+$')
if [[ ${#MEMBERS[@]} -eq 0 ]]
then
    [[ $? -ne 0 ]] && { echo "Error: failed to get members"; exit 3; }
    rm -rf "$SRC_DIR"/* && { echo "Error: no members"; exit 4; }
    echo "Error: no members; failed while removing local src"
    exit 5
fi

# get local src dirs
declare -a LOCAL_SRC_DIRS=()
LOCAL_SRC_DIRS=$(find $SRC_DIR/* -maxdepth 0 2>/dev/null | sed -E 's/.*\/(.*)$/\1/')

# remove extraneous dirs
for local_src_dir in ${LOCAL_SRC_DIRS[@]}
do
    [[ " ${MEMBERS[*]} " =~ [[:space:]]${local_src_dir}[[:space:]] ]] || rm -rf "$SRC_DIR/$local_src_dir"
done

# sync members
for member in ${MEMBERS[@]}
do
    mkdir -p "$SRC_DIR/$member"
    rclone sync "$REMOTE:$member" "$SRC_DIR/$member"
    [[ $? -eq 0 ]] && echo "  sync'd: $member" || echo "Error: sync failed for member: $member"
    [[ -z "$(ls "$SRC_DIR/$member")" ]] && rm -rf $SRC_DIR/$member
done

exit 0

