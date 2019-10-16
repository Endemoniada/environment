###
# SYSTEM
###

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -d ~/bin ]] && export PATH=~/bin:$PATH

# Evaluate `uname -s` and set the result as the name of a variable with the value "true"
# This way it's trivial to add checks for new systems. All you need to do is check the variable named
# from the system descriptor.
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

# Python
alias pyclean='find . -name "*.pyc" -delete'

# Standard ls alises
[[ "$Darwin" ]] && alias ls='ls -G' || alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ll -a'
alias lh='ll -h'
alias l='ll'
alias fuck='sudo $(fc -ln -1)'
alias please='sudo -E'

[[ "$Darwin" ]] && alias sleeplog='pmset -g log | grep -e " Sleep  " -e " Wake  "'



###
# SCRIPTS
###

if [[ "$Darwin" ]]; then
  # Scripts and variables for various applications installed through homebrew
  if [[ $(which brew) ]]; then
      # Git Bash completion
      if [[ -f $(brew --prefix)/etc/bash_completion ]]; then
          source $(brew --prefix)/etc/bash_completion
      fi
      GIT_PS1_SHOWDIRTYSTATE=true
      if [[ -f $(brew --prefix)/etc/bash_completion.d/git-prompt.sh ]]; then
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
      if [[ -f $(brew --prefix)/bin/virtualenvwrapper.sh ]]; then
          source $(brew --prefix)/bin/virtualenvwrapper.sh
      fi
  #    export PIP_REQUIRE_VIRTUALENV=true

      # Byobu configuration
      export BYOBU_PREFIX=$(brew --prefix)
  fi
fi
if [[ $Linux ]]; then
  # Scripts and variables for various applications installed through homebrew
    # Git Bash completion
    if [[ -f /usr/share/bash_completion ]]; then
        source /usr/share/bash_completion
    fi
    GIT_PS1_SHOWDIRTYSTATE=true
#    if [[ -f /usr/share/git/completion/git-completion.bash ]]; then
#        source /usr/share/git/completion/git-completion.bash
#       bashgitprompt='$(__git_ps1 " (%s)")'
#    fi

    # Python VirtualEnv wrapper
    if [[ -f /usr/bin/virtualenvwrapper.sh ]]; then
        source /usr/bin/virtualenvwrapper.sh
    fi
    export PIP_REQUIRE_VIRTUALENV=true
fi

# Homebrew API key
#export HOMEBREW_GITHUB_API_TOKEN=""



###
# PS1
###

# Old prompt

# # Add hostname if connected by SSH
# if [[ ! -z "$SSH_CLIENT" ]]; then ssh='\[\e[1m\]\[\033[38;5;254m\] \h\[$(tput sgr0)\]'; fi
# # Set user/root bash prompt
# if [[ ${EUID} -eq 0 ]]; then
#         # Red root prompt
#         export PS1='\[$(tput sgr0)\]\[\033[38;5;3m\]\A\[$(tput sgr0)\] \[\033[38;5;9m\]\u'"$ssh"' \[$(tput sgr0)\]\w \[\033[38;5;9m\]\$ \[$(tput sgr0)\]'
# else
#         # Green user prompt
#         export PS1='\[$(tput sgr0)\]\[\033[38;5;3m\]\A\[$(tput sgr0)\] \[\033[38;5;10m\]\u'"$ssh"' \[$(tput sgr0)\]\w\[\e[1m\]\[\033[38;5;254m\]'"$bashgitprompt"'\[$(tput sgr0)\] \$ '
# fi

# PS1 prompt courtesy of Corey Schafer
# Shell prompt based on the Solarized Dark theme.
# Screenshot: http://i.imgur.com/EkEtphC.png
# Heavily inspired by @necolas’s prompt: https://github.com/necolas/dotfiles
# iTerm → Profiles → Text → use 13pt Monaco with 1.1 vertical spacing.

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 153);
	green=$(tput setaf 71);
	orange=$(tput setaf 166);
	red=$(tput setaf 167);
	white=$(tput setaf 15);
	yellow=$(tput setaf 228);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	green="\e[1;32m";
	orange="\e[1;33m";
	red="\e[1;31m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${yellow}";
fi;

# Set the terminal title to the current working directory.
PS1="\[\033]0;\w\007\]";
PS1+="\n"; # newline
PS1+="\[${white}\]\A " # time
PS1+="\[${bold}\]\[${userStyle}\]\u"; # username
if [[ "${SSH_TTY}" ]]; then
    PS1+="\[${white}\] at ";
    PS1+="\[${hostStyle}\]\h"; # host
fi
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\w"; # working directory
PS1+="\$(prompt_git \"\[${white}\] on \[${blue}\]\" \"\[${blue}\]\")"; # Git repository details
PS1+=" \[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
