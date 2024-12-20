#!/usr/bin/env bash

# Sync photos periodically

WAIT_TIME=$((24*60))

while true
do
    sleep $(($WAIT_TIME*60))
    bash ./sync.sh
done

