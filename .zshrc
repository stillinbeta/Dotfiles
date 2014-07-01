# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored
zstyle :compinstall filename '/home/sib/.zshrc'

#Include useful things
autoload -Uz compinit promptinit colors vcs_info
compinit
zstyle ':completion:*' menu select
promptinit
colors

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd
setopt prompt_subst
setopt correct
unsetopt beep

setopt extended_glob

bindkey -v
# End of lines configured by zsh-newuser-install
zmodload -i zsh/complist
zstyle ':completion:*:mosh' menu known-hosts-files

compdef 'python manage.py'='manage.py'
compdef mosh=ssh

PROMPT='%{${VIMODE}%}%(!.#.$)%b%{$reset_color%} '
RPROMPT='%B%n@%m:%~'
function selector {
        VIMODE="${${KEYMAP/vicmd/${fg[yellow]}}/(main|viins)/%(?..$fg[red])}"
        zle reset-prompt
}

# Global shared history
setopt INC_APPEND_HISTORY

PATH="$HOME/.rbenv/shims:$PATH"

#Setup Virtualenv stuff
VIRTUAL_ENV_DISABLE_PROMPT=1
function virtualenv_info {
        [ $VIRTUAL_ENV ] && echo `basename $VIRTUAL_ENV`
}

zle -N zle-line-init selector
zle -N zle-keymap-select selector

export EDITOR="vim"

#Add some colour to things
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#Useful commands
alias nosleep="xset s off && xset -dpms"
alias jesus="sudo"
alias vless="/usr/share/vim/vim74/macros/less.sh"

function cd {
    readlink -f $1 > /tmp/.zsh-last-cd 2>/dev/null
    builtin cd $@
}

function mkcd {
    mkdir -p $1 && cd $1
}

function print_cdf {
    file=$1
    shift
    ssh cdf "/local/bin/print $@" < $file
}


#Ignore all this crap
fignore=( .o \~ .pyc .hi .aux)

# Stuff for go
export GOPATH=$HOME/Devel/go
export PATH=$PATH:$HOME/Devel/go/bin

if [[ -f /tmp/.zsh-last-cd && -d "$(cat /tmp/.zsh-last-cd)" ]] ; then
    cd $(cat /tmp/.zsh-last-cd)
fi
