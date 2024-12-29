#!/usr/bin/env bash

# Cycle

. ./vars/set_vars.sh

while true
do
    echo "> cycle: new cycle"

    python ./main/slideshow.py $SRC_DIR $ACTIVE_DIR $ACTIVE_INTERVAL &
    sleep $SYNC_INTERVAL

    pkill -f -TERM "main/slideshow.py"
    bash ./main/sync.sh
done

