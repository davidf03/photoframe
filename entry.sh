#!/usr/bin/env bash

# Entry/startup

echo "> ./entry.sh"

cd /home/pi/Pictures/frame

# git pull --rebase origin main >/dev/null 2>/dev/null

bash ./main/main.sh
exit $?

