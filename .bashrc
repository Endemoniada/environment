# Byobu configuration
export BYOBU_PREFIX=$(brew --prefix)

# SSH alises
alias rpi="ssh -i .ssh/<privatekey> user@host"
alias mm="ssh -i .ssh/<privatekey> user@host"

# Git
# You must install Git first - ""
alias gs='git status -sb'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias gf='git fetch'
alias gl="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

# Standard ls alises
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -la'

# Other alises
alias sleeplog='pmset -g log | grep -e " Sleep  " -e " Wake  "'

