#!/usr/bin/env bash

# Main

. ./set_vars.sh

SYNC_INTERVAL=$(( 24 * 60 * 60 ))

while true
do
    echo "> main: new cycle"
    python ./slideshow.py $ACTIVE_INTERVAL &
    sleep $SYNC_INTERVAL
    kill $!
    bash ./sync.sh
done

