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

# Ruby
PATH="$HOME/.rbenv/shims:/home/liz/.gem/ruby/2.1.0/bin:$PATH:$HOME/Scripts"
alias ber="bundle exec rake"
alias rr="forego run bundle exec"

# Stuff for go
cdpath=(~/Code ~/Code/kernel/ ~/Code/go/src/github.com/heroku)
export GOPATH=$HOME/Code/go
export PATH=$PATH:$HOME/Code/go/bin

# Stuff for erlang
export MANPATH="/usr/share/man:/usr/lib/erlang/man"
function ka {
    . ~/erlang/$1/activate
}

function kerl_path {
    if KERL=$(basename $_KERL_ACTIVE_DIR 2>/dev/null); then
        KERL_PROMPT=" {$KERL} "
    else
        KERL_PROMPT=""
    fi
}


# Python
compdef 'python manage.py'='manage.py'

#Vagrat
export VAGRANT_DEFAULT_PROVIDER=libvirt

zle -N zle-line-init selector
zle -N zle-keymap-select selector

export EDITOR="vim"
export BROWSER="google-chrome-stable"
export LC_ALL=en_GB.UTF-8

#Add some colour to things
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#Useful commands
alias nosleep="xset s off && xset -dpms"
alias vless="/usr/share/vim/vim74/macros/less.sh"
alias dc="docker-compose"
alias db='forego run psql \$DATABASE_URL'
alias fuck='$(thefuck $(fc -ln -1))'

function mkcd {
    mkdir -p $1 && cd $1
}

# Prompt

PROMPT='%{${VIMODE}%}%(!.#.$)%b%{$reset_color%} '
RPROMPT='${vcs_info_msg_0_}${KERL_PROMPT} ${CLOUD_ICON} %~'

function selector {
    VIMODE="${${KEYMAP/vicmd/${fg[yellow]}}/(main|viins)/%(?..$fg[red])}"
    kerl_path

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

if [[ -f /tmp/.zsh-last-cloud ]] ; then
  c $(cat /tmp/.zsh-last-cloud)
fi

# added by travis gem
[ -f /home/liz/.travis/travis.sh ] && source /home/liz/.travis/travis.sh
