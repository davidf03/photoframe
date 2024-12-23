#!/usr/bin/env bash

# Entry/startup

. ./set_vars.sh

bash ./sync.sh
bash ./main.sh &
sleep 2
feh -R 5 -D 5 -Z -Y $ACTIVE_DIR

