#!/usr/bin/env bash

# Main

bash ./set_vars.sh
bash ./sync.sh
parallel -u ::: './slideshow.sh 1' './sync_routine.sh 2' 

