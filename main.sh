#!/usr/bin/env bash

# Main

. ./set_vars.sh

while true
do
    echo "> main: new cycle"
    python ./slideshow.py $SRC_DIR $ACTIVE_DIR $ACTIVE_INTERVAL &
    sspid=$!
    sleep $SYNC_INTERVAL
    kill $sspid
    bash ./sync.sh
done

