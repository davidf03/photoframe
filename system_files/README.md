# system files, installation
## to hide taskbar in case it ends up competing with the slideshow
- append contents to existing file, for:
    - `~/.config/wf-panel-pi.ini`
## for immediate execution on boot
- add all files to directories per filename in repo, for:
    - `/etc/systemd/system/photoframe.service` and
    - `/usr/local/bin/photoframe.sh`
- ensure these two files and `./entry.sh` point to the repo root (assumed to be `/home/pi/Pictures/frame`)
- ensure `systemctl` pkg is installed
- finally, run commands:
    1. `sudo systemctl enable photoframe.service`
    2. `sudo systemctl daemon-reload`
    3. `chmod +x /usr/local/bin/photoframe.sh` and
    4. `chmod +x /path/to/photoframe/entry.sh`
    - can test is working using `sudo systemctl start photoframe.service` and `sudo reboot`
## for physical wake/shutdown button (shorting header pins 5/GPIO3 and 6/GND)
- append contents to existing file, for:
    - `/boot/config.txt`

