#!/usr/bin/env bash

# Sync photos
# Note: override abusive sync prevention with parameter $1 = 1

echo "> ./main/sync.sh"

. ./vars/set_vars.sh

# vpn
vpn_defined=false
[[ $VPN && ! -z "${VPN}" ]] && vpn_defined=true

if [[ $BYPASS_VPN = true ]]
then
    echo "  vpn bypassed"
    exit 0
elif [[ ! $BYPASS_VPN || ! $vpn_defined ]]
then
    while true; do
        read -p "?> no wireguard VPN config reference provided; continue anyway? [y/n] : " yn
        case $yn in
            [Yy] )
                . ./vars/set_bypass_vpn
                echo "!> VPN bypass set for this execution; you can set this permanently in ./config.sh.sh"
                break
                ;;
            [Nn] ) exit 10 ;;
            * ) echo "!> invalid response; answer must be 'y':Yes or 'n':No" ;;
        esac
    done
elif [[ $vpn_defined ]]
then
    sudo wg-quick up "$VPN" >/dev/null 2>/dev/null
    [[ $? -eq 0 || $? -eq 1 ]] || { echo "  error: couldn't establish connection"; exit 11; }
    [[ $(sudo wg | wc -c) -eq 0 ]] && { echo "  error: something wrong with connection"; exit 12; }
    echo "  connected"
fi

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
member_get_status=$?
if [[ ${#members[@]} -eq 0 ]]
then
    [[ $member_get_status -ne 0 ]] && { echo "  error: failed to get members"; exit 20; }
    rm -rf "$SRC_DIR"/* && { echo "  error: no members"; exit 21; }
    echo "  error: no members; failed while removing local src"
    exit 22
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

