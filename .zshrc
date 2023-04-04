# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored

#Include useful things
autoload -Uz compinit promptinit colors vcs_info
compinit
zstyle ':completion:*' menu select
promptinit
colors

autoload bashcompinit && bashcompinit

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

source ~/.zshenv

# Global shared history
setopt INC_APPEND_HISTORY
export REPORTTIME=1

# Python
compdef 'python manage.py'='manage.py'

#Add some colour to things
alias ls="ls --color=auto"
alias grep="grep --color=auto"

#Useful commands
alias dc="docker-compose"

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


if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

if which ruby >/dev/null && which gem >/dev/null; then
    PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

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

complete -C '~/.local/bin/aws_completer' aws

source <(kubectl completion zsh)
alias k=kubectl

eval "$(direnv hook zsh)"
