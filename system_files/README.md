# system files, installation
- add all files to directories per filename in repo, for:
    - `/etc/systemd/system/photoframe.service` and
    - `/usr/local/bin/photoframe.sh`
- append contents to existing file, for:
    - `/boot/config.txt` (this one only necessary for physical shutdown/boot button shorting header pins 5/GPIO3 and 6/GND) and
    - `~/.config/wf-panel-pi.ini` (to hide taskbar in case it ends up competing with the slideshow)
- also run commands:
    1. `sudo systemctl enable photoframe.service`
    2. `sudo systemctl daemon-reload`
    3. `chmod +x /usr/local/bin/photoframe.sh` and
    4. `chmod +x /path/to/photoframe/entry.sh`
 - ensure `/etc/systemd/system/photoframe.service`, `/usr/local/bin/photoframe.sh` and `/path/to/photoframe/entry.sh` point to the repo root (assumed to be `/home/pi/Pictures/frame`)

