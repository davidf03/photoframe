#!/usr/bin/env bash

# Main

echo "> main"

. ./vars/set_vars.sh

bash ./main/sync.sh
sync_res=$?
[[ $sync_res -eq 10 ]] && exit 0
[[ $sync_res -eq 11 || $sync_res -eq 12 ]] && exit 2
bash ./main/cycle.sh &
sleep 5
feh -R $ACTIVE_INTERVAL -D $ACTIVE_INTERVAL -Z -F -Y $ACTIVE_DIR

exit 0

