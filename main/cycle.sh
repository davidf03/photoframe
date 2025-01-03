#!/usr/bin/env bash

# Cycle

. ./vars/set_vars.sh

while true
do
    echo "> ./main/cycle.sh: new cycle"

    python ./main/slideshow.py $SRC_DIR $ACTIVE_DIR $ACTIVE_INTERVAL "$([ -f ./extensions ] && cat ./extensions)" &
    sleep $SYNC_INTERVAL

    pkill -f -TERM "main/slideshow.py"
    bash ./main/sync.sh
done

