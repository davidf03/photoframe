# README
## dependencies
- `rclone` & config for cloud drive access (name of config assigned to `$REMOTE` env var in `set_vars.sh`)
- `wireguard` & config for your vpn, if desired (otherwise remove vpn lines from `sync.sh`; name of config assigned to `$VPN` env var in `set_vars.sh`)
    - `openresolv` pkg was missing for me and needed to be installed, per https://askubuntu.com/a/1464069
- certain system files to be installed/modified per `./system_files/README.md`

