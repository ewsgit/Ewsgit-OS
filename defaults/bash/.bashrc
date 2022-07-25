source ~/config/config/ewsgit-bash/linker.sh

case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=200
HISTFILESIZE=200
shopt -s checkwinsize

PS1='\e[m[\e[0;31m\u\e[m@\h] \e[0;32m\w \$\e[m '

     alias ls='ls --color=auto'
     alias dir='dir --color=auto'
     alias vdir='vdir --color=auto'

     alias grep='grep --color=auto'
     alias fgrep='fgrep --color=auto'
     alias egrep='egrep --color=auto'

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -l'
alias l="ls -la"
alias la='ls -A'

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias cl="clear"
alias cls="clear"
alias ns="npm run start"
alias nt="npm run test"
alias ls="ls -a"
alias vim="nvim"
alias edit="nvim"
alias ed="nvim"
alias su="sudo su -p"
alias ls="exa"
alias l="ls"
alias ll="ls"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

EDITOR=nvim

export PATH="~/Path:$PATH"
PATH=~/.local/bin/:$PATH
PATH=~/.neovimApp/:$PATH
PATH=~/path/:$PATH
