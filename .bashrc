# Byobu configuration
export BYOBU_PREFIX=$(brew --prefix)

# SSH alises
alias rpi="ssh -i ~/.ssh/endemoniada nathaniel@rpi"
alias mm="ssh -i ~/.ssh/endemoniada martin@macmini"

# Git
# You must install Git first - ""
alias gs='git status -sb'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git pull'
alias gf='git fetch'
alias gl="git log --all --graph --pretty=format:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

# Standard ls alises
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -lA'

# Other alises
alias sleeplog='pmset -g log | grep -e " Sleep  " -e " Wake  "'

[ -f ~/.bashrc-fujitsu ] && . ~/.bashrc-fujitsu
