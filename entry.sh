#!/usr/bin/env bash

# Entry/startup

echo "> photoframe"

cd /home/pi/Pictures/frame

. ./set_vars.sh

bash ./sync.sh
[[ $? -eq 1 || $? -eq 2 ]] && exit 1
bash ./main.sh &
sleep 2
feh -R $ACTIVE_INTERVAL -D $ACTIVE_INTERVAL --zoom fill -F -Y $ACTIVE_DIR

exit 0

