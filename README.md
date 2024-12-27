# README
## Dependencies
- `systemctl` pkg to set up daemon for immediate execution on boot
- `rclone` & config for cloud drive access (name of config assigned to $REMOTE env var in `set_vars.sh`)
- wireguard & config for vpn, if desired (otherwise remove vpn lines from `sync.sh`; name of config assigned to $VPN env var in `set_vars.sh`)
    - `openresolv` pkg needed to be installed for me, per https://askubuntu.com/a/1464069
- system files to be installed per this repo's `system_files/README.md`

