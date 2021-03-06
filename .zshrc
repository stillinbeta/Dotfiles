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
HISTSIZE=1000
SAVEHIST=1000
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

PROMPT='%B%n@%m:%~%{${VIMODE}%}%(!.#.$)%b%{$reset_color%} '
function selector {
        VIMODE="${${KEYMAP/vicmd/${fg[yellow]}}/(main|viins)/%(?..$fg[red])}"
        zle reset-prompt
}

# Global shared history
setopt INC_APPEND_HISTORY

PATH="$PATH:/home/sib/.gem/ruby/1.9.1/bin"

#Setup Virtualenv stuff
VIRTUAL_ENV_DISABLE_PROMPT=1
function virtualenv_info {
        [ $VIRTUAL_ENV ] && echo `basename $VIRTUAL_ENV`
}

#Git stuff
#Blatantly stolen from oh my zsh
. ~/Scripts/git.zsh

#maybe I needing later
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#Add a seperator if need be
function sep {
    [ `virtualenv_info` ] && [ `git_prompt_info` ] && echo '|'
}
RPROMPT='$(virtualenv_info)$(sep)$(git_prompt_info)'

zle -N zle-line-init selector
zle -N zle-keymap-select selector

export EDITOR="vim"

#Add some colour to things
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#Useful commands
alias backup_sib="rsync -av --delete --exclude-from=/home/sib/.rsync-exclude ~"
alias nosleep="xset s off && xset -dpms"
alias jesus="sudo"
alias vless="/usr/share/vim/vim73/macros/less.sh"
alias mount.tc="truecrypt -t -k '' --protect-hidden=no --mount "
alias umount.tc="truecrypt -t --dismount"
alias wi="wicd-curses"
alias erl="rlwrap erl -oldshell"
alias inventory="ruby /home/sib/Devel/ruby/inventory/inventory.rb"
alias lock="xscreensaver-command -lock"
alias cdf='mosh --server="LD_LIBRARY_PATH=~/mosh/lib LANG=C.UTF-8 ~/mosh/bin/mosh-server" cdf'


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
