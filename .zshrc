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
setopt extended_glob

bindkey -v
# End of lines configured by zsh-newuser-install
zmodload -i zsh/complist
zstyle ':completion:*:mosh' menu known-hosts-files

compdef 'python manage.py'='manage.py'
compdef mosh=ssh

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "%b"
zstyle ':vcs_info:git*' actionformats "%b (%a)"
precmd() {
      vcs_info
}

PROMPT='%{${VIMODE}%}%(!.#.$)%b%{$reset_color%} '
RPROMPT='${vcs_info_msg_0_} ${CLOUD_ICON} %~'
function selector {
        VIMODE="${${KEYMAP/vicmd/${fg[yellow]}}/(main|viins)/%(?..$fg[red])}"
        case "$HEROKU_CLOUD" in
            liz)
                CLOUD_COLOUR="${fg[red]}"
                ;;
            staging)
                CLOUD_COLOUR="${fg[yellow]}"
                ;;
            production|"")
                CLOUD_COLOUR="${fg[green]}"
                ;;
        esac
        CLOUD_ICON="%{$CLOUD_COLOUR%}☁%{$reset_color%}"

        zle reset-prompt
}

# Global shared history
setopt INC_APPEND_HISTORY

PATH="$HOME/.rbenv/shims:/home/liz/.gem/ruby/2.1.0/bin:$PATH:$HOME/Scripts"

# Stuff for go
cdpath=(~/Code ~/Code/go/src/github.com/heroku)
export GOPATH=$HOME/Code/go
export PATH=$PATH:$HOME/Code/go/bin


#Setup Virtualenv stuff
VIRTUAL_ENV_DISABLE_PROMPT=1
function virtualenv_info {
        [ $VIRTUAL_ENV ] && echo `basename $VIRTUAL_ENV`
}

zle -N zle-line-init selector
zle -N zle-keymap-select selector

export EDITOR="vim"
export LC_ALL=en_GB.UTF-8

#Add some colour to things
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#Useful commands
alias nosleep="xset s off && xset -dpms"
alias vless="/usr/share/vim/vim74/macros/less.sh"
alias rr="forego run bundle exec"
alias anyc="(builtin cd ~/Downloads/anyconnect-3.1.03103/vpn/ && sudo ./vpn_install.sh)"
alias shipit="heroku preauth -r production && git push production master"
alias dc="docker-compose"
alias db='forego run psql \$DATABASE_URL'
alias fuck='$(thefuck $(fc -ln -1))'
alias h="~/.heroku/heroku-cli"
alias ic="ion-client"
alias ber="bundle exec rake"


source /usr/bin/aws_zsh_completer.sh
function cd {
    builtin cd $@
    pwd > /tmp/.zsh-last-cd 2>/dev/null
}

function mkcd {
    mkdir -p $1 && cd $1
}

cloud() {
  eval "$(ion-client shell)"
  cloud "$@"
}

export SSH_AUTH_SOCK=/run/user/1000/keyring/ssh
export GPG_AGENT_INFO=/run/user/1000/keyring/gpg:0:1

#Ignore all this crap
fignore=( .o \~ .pyc .hi .aux)

if [[ -f /tmp/.zsh-last-cd && -d "$(cat /tmp/.zsh-last-cd)" ]] ; then
    cd $(cat /tmp/.zsh-last-cd)
fi

# added by travis gem
[ -f /home/liz/.travis/travis.sh ] && source /home/liz/.travis/travis.sh
