#/bin/bash
#       The bash executable
#/etc/profile
#       The systemwide initialization file, executed for login shells
#~/.bash_profile
#       The personal initialization file, executed for login shells
#~/.bashrc
#       The individual per-interactive-shell startup file
#~/.bash_logout
#       The individual login shell cleanup file, executed when a login shell exits
#~/.inputrc
#       Individual readline initialization file


# Old PS1 prompt
# 17:28 [martin@iMac:~]$ 
#    PS1="\[\033[38;5;253m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;7m\][\[$(tput sgr0)\]\[\033[38;5;10m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;7m\]@\[$(tput sgr0)\]\[\033[38;5;253m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;2m\]\w\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;7m\]]\[$(tput sgr0)\]\[\033[38;5;2m\]\\$\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# Git bash-completion and configuration
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi
GIT_PS1_SHOWDIRTYSTATE=true
if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
  source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
fi
if [ -f $(brew --prefix)/bin/virtualenvwrapper.sh ]; then
  source $(brew --prefix)/bin/virtualenvwrapper.sh 
fi
export PIP_REQUIRE_VIRTUALENV=true 

# Homebrew API key
export HOMEBREW_GITHUB_API_TOKEN=""


# Add hostname if connected by SSH
if [ -n "$SSH_CLIENT" ]; then ssh='\[\e[1m\]\[\033[38;5;254m\] \h\[$(tput sgr0)\]'; fi
# Set user/root bash prompt
if [ ${EUID} -eq 0 ]; then
        # Red root prompt
        export PS1='\[$(tput sgr0)\]\[\033[38;5;3m\]\A\[$(tput sgr0)\] \[\033[38;5;9m\]\u'"$ssh"' \[$(tput sgr0)\]\w \[\033[38;5;9m\]\$ \[$(tput sgr0)\]'
else
        # Green user prompt
        export PS1='\[$(tput sgr0)\]\[\033[38;5;3m\]\A\[$(tput sgr0)\] \[\033[38;5;10m\]\u'"$ssh"' \[$(tput sgr0)\]\w\[\e[1m\]\[\033[38;5;254m\]$(__git_ps1)\[$(tput sgr0)\] \$ '
fi

# Lastly, import .bashrc since it's not read by default
[ -r ~/.bashrc ] && source ~/.bashrc
