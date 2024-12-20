#!/usr/bin/env bash

# Main

SYNC_INTERVAL=$(( 24 * 60 * 60 ))

while true
do
    python ./slideshow.py &
    sleep $SYNC_INTERVAL
    kill $!
    bash ./sync.sh
done

