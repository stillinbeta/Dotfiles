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
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


compdef 'python manage.py' './manage.py'
#compdef 'sudo' 'jesus'

PROMPT='%B%n@%m:%~%{${VIMODE}%}%(!.#.$)%b%{$reset_color%} '
function selector {
        VIMODE="${${KEYMAP/vicmd/${fg[yellow]}}/(main|viins)/%(?..$fg[red])}"
        zle reset-prompt
}

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

#Add some colour to things
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#Useful commands
alias backup_sib="rsync -avd --exclude '*Videos*' ~ rsync://sib@192.168.1.1/backup"
alias nosleep="xset s off && xset -dpms"
alias jesus="sudo"
alias vless="/usr/share/vim/vim73/macros/less.sh"
alias vi=vim
alias mount.tc="truecrypt -t -k '' --protect-hidden=no --mount "
alias umount.tc="truecrypt -t --dismount"

function mkcd {
    mkdir -p $1 && cd $1
}

#Ignore all this crap
fignore=( .o \~ .pyc .hi .aux) 
