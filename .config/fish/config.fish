# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

status is-login; and begin

    # Login shell initialisation

end

set -gx ASDF_GOLANG_MOD_VERSION_ENABLED "true"

if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

if not contains $HOME/.local/bin $PATH
    set -gx --prepend PATH $HOME/.local/bin
end

if not contains $HOME/.asdf/bin $PATH
    set -gx --prepend PATH $HOME/.asdf/bin
end

status is-interactive; and begin
    set --global fish_key_bindings fish_vi_key_bindings

    set -g fish_transient_prompt 1

    # Abbreviations
    abbr --add k kubectl

    # Aliases

    # Interactive shell initialisation
    begin
        set -l joined (string join " " $fish_complete_path)
        set -l prev_joined (string replace --regex "[^\s]*generated_completions.*" "" $joined)
        set -l post_joined (string replace $prev_joined "" $joined)
        set -l prev (string split " " (string trim $prev_joined))
        set -l post (string split " " (string trim $post_joined))
    end

    function __aws_complete
        set --local --export COMP_SHELL fish
        set --local --export COMP_LINE (commandline -pc)

        if string match -q -- - (commandline -pt)
            set COMP_LINE "$COMP_LINE-"
        end

        aws_completer | command sed 's/ $//'
    end

    # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
    complete --command aws --no-files --arguments '(__aws_complete)'

    if type -q up
          up completion | source
    end
    if type -q crossplane
        crossplane completions | source
    end
    if type -q direnv
      direnv hook fish | source
    end
    if type -q helmfile
      helmfile completion fish | source
    end
    if type -q kubectl
        kubectl completion fish | source
    end
end
