#!/usr/bin/env bash

# Cycle

. ./vars/set_vars.sh

while true
do
    echo "> cycle: new cycle"
    python ./main/slideshow.py $SRC_DIR $ACTIVE_DIR $ACTIVE_INTERVAL &
    sspid=$!
    sleep $SYNC_INTERVAL
    kill $sspid
    bash ./main/sync.sh
done

