#!/usr/bin/env bash

# Entry/startup

cd /home/pi/Pictures/frame

sudo . ./set_vars.sh

bash ./sync.sh
[[ $? -eq 1 || $? -eq 2 ]] && exit 1
bash ./main.sh &
sleep 2
feh -R 5 -D 5 -Z -Y $ACTIVE_DIR

exit 0

