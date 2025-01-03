#!/usr/bin/env bash

# Kill/clean up background process ids

echo "> kill extant background processes"

pkill -f -TERM "main/slideshow.py"
pkill -f -TERM "main/cycle.sh"
pkill -f -TERM "main/main.sh"

