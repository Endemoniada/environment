# environment
Just my own bash scripts, tmux configs and other stuff

## Files

### .bash_profile
interactive login script, sets advanced prompt with git and python virtualenv expansion.
Put all heavy scripts and more complicated user-oriented stuff here.
Loads .bashrc at the end.

### .bashrc
interactive/non-interactive non-login script, sets some common aliases.
Put anything necessary for non-interactive shell scripts and other things here, like important environment variables.

### .tmux.config
Nice tmux config for dark console themes (like Chalk.terminal, for example), with high-contrast window numbering and useful status information along the bottom.
Uses the getbatt.sh script (install it to ~/bin/ or change the location in the config) to read Macbook battery information.

### bin/getbatt.sh
Simple bash script to output remaining charge on Macbook battery, or remaining time to full charge when on AC power.

### .vimrc
Honestly, modern Vim installations work great out of the box, but I at least want syntax highlighting turned on... ;)

### Terminal themes/
A directory with some of my favorite terminal themes.

## Installation
Just copy the dot-files to your home directory and make sure they're executable.
Make a directory ~/bin/ and put the getbatt.sh script in there (along with other scripts you might have, many platforms load ~/bin/ into their path variables automatically), or optionally put it anywhere you like and change the tmux configuration accordingly.
The Terminal themes can be installed by simply double clicking on them. They will open a new terminal window with the theme applied so you can check it out. To set it permanently, open Terminal settings and click "Default" on the theme you like.
