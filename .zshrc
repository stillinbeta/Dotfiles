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

setopt auto_list            ## Automatically list choices on completion
setopt auto_menu            ## perform menu completion on subsequent completes
setopt inc_append_history   ## Append history lines as they are executed, not only on exit
setopt listambiguous        ## autolists second completions if 1st ambiguous
setopt list_ambiguous       ## List options even if we can complete some prefix first
setopt list_types           ## show file types when completing
setopt no_list_beep         ## don't beep ambiguous completions
setopt notify               ## Report status of background jobs immediately
setopt print_exit_value     ## Print non-zero exit status
setopt rm_star_wait         ## Force a pause before allowing an answer on rm *
setopt transient_rprompt    ## Remove the right-side prompt if the cursor comes close
setopt appendhistory
setopt autocd
setopt prompt_subst
setopt correct
unsetopt beep
#setopt extended_glob

bindkey -v
# End of lines configured by zsh-newuser-install
zmodload -i zsh/complist

# Git
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%b"
zstyle ':vcs_info:git*' actionformats "%b (%a)"
precmd() {
      vcs_info
}

# Global shared history
setopt INC_APPEND_HISTORY
export REPORTTIME=1

# Stuff for go
cdpath=(~/Code ~/Code/src/github.com/heptio/ )
export GOPATH=$HOME
export PATH=$PATH:$HOME/bin

if [ $commands[kubectl] ]; then
    source <(kubectl completion zsh)
fi

zle -N zle-line-init selector
zle -N zle-keymap-select selector

export EDITOR="emacsclient --tty"
export BROWSER="google-chrome-stable"
export LC_ALL=en_GB.UTF-8

#Useful commands
alias dc="docker-compose"
alias fuck='$(thefuck $(fc -ln -1))'

function mkcd {
    mkdir -p $1 && cd $1
}

# Prompt

PROMPT='%{${VIMODE}%}%(!.#.$)%b%{$reset_color%} '
RPROMPT='${vcs_info_msg_0_} %~'

function selector {
    VIMODE="${${KEYMAP/vicmd/${fg[yellow]}}/(main|viins)/%(?..$fg[red])}"
    zle reset-prompt
}

export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
export GPG_AGENT_INFO=/run/user/1000/keyring/gpg:0:1

#Ignore all this crap
fignore=( .o \~ .pyc .hi .aux)

# open in last open directory
function cd {
    builtin cd $@
    pwd > /tmp/.zsh-last-cd 2>/dev/null
}
if [[ -f /tmp/.zsh-last-cd && -d "$(cat /tmp/.zsh-last-cd)" ]] ; then
    cd $(cat /tmp/.zsh-last-cd)
fi
