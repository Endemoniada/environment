[![forthebadge](https://forthebadge.com/images/badges/approved-by-veridian-dynamics.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/built-with-resentment.svg)](https://forthebadge.com)

# environment
Just my own bash scripts, tmux configs and other stuff

## Files

### bin/getbatt.sh
Simple bash script to output remaining charge on Macbook battery, or remaining time to full charge when on AC power.

### Terminal themes/
A directory with some of my favorite terminal themes.

### systemd/
Contains various systemd unit files

### backup.sh/
Contains script and default configuration file for the backup.sh script

## Installation
Run './installer.sh <e-mail>' to automatically copy over all your dotfiles, and configure .gitconfig with your e-mail address. Any existing files will be copied to '.orig<filename>' as backup.
Optional: You can also install the backup script and its systemd unit files.

Make a directory ~/bin/ and put the getbatt.sh script in there (along with other scripts you might have, many platforms load ~/bin/ into their path variables automatically), or optionally put it anywhere you like and change the tmux configuration accordingly.

The Terminal themes can be installed by simply double clicking on them. They will open a new terminal window with the theme applied so you can check it out. To set it permanently, open Terminal settings and click "Default" on the theme you like.

[![forthebadge](https://forthebadge.com/images/badges/just-plain-nasty.svg)](https://forthebadge.com) [![forthebadge](https://forthebadge.com/images/badges/winter-is-coming.svg)](https://forthebadge.com)
