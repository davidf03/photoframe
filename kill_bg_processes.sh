#!/usr/bin/env bash

# Kill/clean up background process ids

echo "> ./kill_bg_processes.sh"

pkill -f -TERM "main/slideshow.py"
pkill -f -TERM "main/cycle.sh"
pkill -f -TERM "main/main.sh"

