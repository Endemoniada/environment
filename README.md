# environment
Just my own bash scripts, tmux configs and other stuff

## Files

### bin/getbatt.sh
Simple bash script to output remaining charge on Macbook battery, or remaining time to full charge when on AC power.

### Terminal themes/
A directory with some of my favorite terminal themes.

## Installation
run './installer.sh <e-mail>' to automatically copy over all dotfiles, and configure .gitconfig with your e-mail address. Any existing files will be copied to '.orig<filename>' as backup.
Make a directory ~/bin/ and put the getbatt.sh script in there (along with other scripts you might have, many platforms load ~/bin/ into their path variables automatically), or optionally put it anywhere you like and change the tmux configuration accordingly.
The Terminal themes can be installed by simply double clicking on them. They will open a new terminal window with the theme applied so you can check it out. To set it permanently, open Terminal settings and click "Default" on the theme you like.
