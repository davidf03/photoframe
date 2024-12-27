#!/usr/bin/env bash

# Sync photos
# Note: override abusive sync prevention with parameter $1 = 1

echo "> sync.sh"

. ./set_vars.sh

# vpn
sudo wg-quick up "$VPN" >/dev/null 2>/dev/null
[[ $? -eq 0 || $? -eq 1 ]] || { echo "  error: couldn't establish connection"; exit 1; }
[[ $(sudo wg | wc -c) -eq 0 ]] && { echo "  error: something wrong with connection"; exit 2; }
echo "  connected"

# abusive traffic-flag safeguard
exec_date=$(date '+%s')
if [[ $1 -eq 1 || ! -f ./.last_sync || $exec_date -gt $(( $(cat ./.last_sync) + $SYNC_INTERVAL )) ]]
then
    echo $exec_date > ./.last_sync
else
    echo "  sync too recent"
    exit 0
fi

# get members
declare -a members=()
members=$(rclone lsd "$REMOTE": | grep -o '\S\+$')
if [[ ${#members[@]} -eq 0 ]]
then
    [[ $? -ne 0 ]] && { echo "  error: failed to get members"; exit 3; }
    rm -rf "$SRC_DIR"/* && { echo "  error: no members"; exit 4; }
    echo "  error: no members; failed while removing local src"
    exit 5
fi

# get local src dirs
declare -a local_src_dirs=()
local_src_dirs=$(find $SRC_DIR/* -maxdepth 0 2>/dev/null | sed -E 's/.*\/(.*)$/\1/')

# remove extraneous dirs
for local_src_dir in ${local_src_dirs[@]}
do
    [[ " ${members[*]} " =~ [[:space:]]${local_src_dir}[[:space:]] ]] || rm -rf "$SRC_DIR/$local_src_dir"
done

# sync members
for member in ${members[@]}
do
    mkdir -p "$SRC_DIR/$member"
    rclone sync "$REMOTE:$member" "$SRC_DIR/$member"
    [[ $? -eq 0 ]] && echo "  sync'd: $member" || echo "  error: sync failed: $member"
    [[ -z "$(ls "$SRC_DIR/$member")" ]] && rm -rf $SRC_DIR/$member
done

exit 0

