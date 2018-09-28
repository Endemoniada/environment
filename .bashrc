###
# SYSTEM
###

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -d ~/bin ] && export PATH=$PATH:~/bin

eval $(uname -s)=true

###
# ALIASES
###


# Git
# You must install Git first - ""
alias gs='git status -sb'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git pull'
alias gf='git fetch'
alias gl="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
alias gco='git checkout'
alias grb='git rebase'

# Standard ls alises
[ ! -z "$Darwin" ] && alias ls='ls -G' || alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ll -a'
alias l='ll'
alias fuck='sudo $(fc -ln -1)'
alias please='sudo -E'

[ ! -z "$Darwin" ] && alias sleeplog='pmset -g log | grep -e " Sleep  " -e " Wake  "'


###
# SCRIPTS
###

if [ ! -z "$Darwin" ]; then
  # Scripts and variables for various applications installed through homebrew
  if [ $(which brew) ]; then
      # Git Bash completion
      if [ -f $(brew --prefix)/etc/bash_completion ]; then
          source $(brew --prefix)/etc/bash_completion
      fi
      GIT_PS1_SHOWDIRTYSTATE=true
      if [ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]; then
          source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
          bashgitprompt='$(__git_ps1)'
      fi

      # Python virtual environments:
      # https://github.com/registerguard/registerguard.github.com/wiki/Install-python,-virtualenv,-virtualenvwrapper-in-a-brew-environment
      export WORKON_HOME=$HOME/.virtualenvs
      #export WORKON_HOME=/tmp/foo/.virtualenvs
      export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
      export PIP_VIRTUALENV_BASE=$WORKON_HOME
      export PIP_RESPECT_VIRTUALENV=true

      # Python VirtualEnv wrapper
      if [ -f $(brew --prefix)/bin/virtualenvwrapper.sh ]; then
          source $(brew --prefix)/bin/virtualenvwrapper.sh
      fi
  #    export PIP_REQUIRE_VIRTUALENV=true

      # Byobu configuration
      export BYOBU_PREFIX=$(brew --prefix)
  fi
elif [ ! -z $Linux ]; then
  # Scripts and variables for various applications installed through homebrew
    # Git Bash completion
    if [ -f /usr/share/bash_completion ]; then
        source /usr/share/bash_completion
    fi
    GIT_PS1_SHOWDIRTYSTATE=true
#    if [ -f /usr/share/git/completion/git-completion.bash ]; then
#        source /usr/share/git/completion/git-completion.bash
#       bashgitprompt='$(__git_ps1 " (%s)")'
#    fi

    # Python VirtualEnv wrapper
    if [ -f /usr/bin/virtualenvwrapper.sh ]; then
        source /usr/bin/virtualenvwrapper.sh
    fi
    export PIP_REQUIRE_VIRTUALENV=true
fi


# Homebrew API key
#export HOMEBREW_GITHUB_API_TOKEN=""


###
# PS1
###

# Add hostname if connected by SSH
if [ ! -z "$SSH_CLIENT" ]; then ssh='\[\e[1m\]\[\033[38;5;254m\] \h\[$(tput sgr0)\]'; fi
# Set user/root bash prompt
if [ ${EUID} -eq 0 ]; then
        # Red root prompt
        export PS1='\[$(tput sgr0)\]\[\033[38;5;3m\]\A\[$(tput sgr0)\] \[\033[38;5;9m\]\u'"$ssh"' \[$(tput sgr0)\]\w \[\033[38;5;9m\]\$ \[$(tput sgr0)\]'
else
        # Green user prompt
        export PS1='\[$(tput sgr0)\]\[\033[38;5;3m\]\A\[$(tput sgr0)\] \[\033[38;5;10m\]\u'"$ssh"' \[$(tput sgr0)\]\w\[\e[1m\]\[\033[38;5;254m\]'"$bashgitprompt"'\[$(tput sgr0)\] \$ '
fi

#Only do this if non-root
if [[ $EUID -ne 0 && "$(hostname -s)" = "archon" ]]; then
  if $(which wurtzisms > /dev/null 2>&1); then
    echo "Wurtzism of the Day:"
    echo
    wurtzisms --instant
  fi
fi
