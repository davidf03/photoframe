#!/usr/bin/env bash

# Sync photos periodically

WAIT_TIME=$((24*60))

while true
do
    bash ./sync.sh
    sleep $((WAIT_TIME*60))
done

