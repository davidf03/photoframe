# README
## what
- digital, network-connected photoframe for self-hosted photos, using a raspberry pi
## why
- to avoid using something proprietary and predatory of personal data, especially images, given the current state of LLM's and their ravenous and insatiable apetites, into the maws of which companies of all sizes seem all too eager to sacrifice even their own grandmothers, and to avoid signing some epic and inscrutable terms and conditions that would surely give this all away in exchange for something that is ultimately kind of frivolous and unnecessary
- and because I wanted to normalise the representation of members of my family in the slideshow, who would contribute in different quantities, to make sure those who did little would still be seen, which didn't seem possible without something more custom
## how
- `feh` was the only utility I could get this to work with; so there are no transitions
- a python script (`./slideshow.py`) selects a member and then a photo from their directory, and redistributes the probability at each level to make it less likely to be selected the next time, until the probability of others, on their selection, is redistributed back: directories have a bias (only a certain amount is removed, less while the member has more photos) and the probability is redistributed to the others with respect to the relative proportion of each, which two things combined skew/normalise representation; photos do not have any bias, and their probability is entirely redistributed each time and equally across all other photos within the member directory
- the python script puts images into an 'active' folder at the same rate that the `feh` slideshow cycles, and the `feh` command, which is run only once, continually rescans the directory at the same rate in turn
- the result isn't much to speak of, but at any rate works
## dependencies
### slideshow
- `feh`
### cloud drive
- `rclone` & config
    - name of config assigned to `$REMOTE` env var in `./config.sh`
### vpn (optional)
- `wireguard` & config
    - name of config assigned to `$VPN` env var in `./config.sh`
    - can permanently override requirement (`$BYPASS_VPN=true` in `./config.sh`) or else be prompted each execution whether to continue without one
    - `openresolv` pkg was missing on my raspberry pi and needed to be installed, per https://askubuntu.com/a/1464069
### system files (optional)
- certain system files (for various purposes) to be optionally installed/modified
- more information on these in `./system_files/README.md`
## configuration
- make a copy of `./config.sh.example` and rename it to exclude the `.example` suffix -> `./config.sh`
- of the variables which are unset, be sure to include at least a name for the `rclone` config in `$REMOTE`

