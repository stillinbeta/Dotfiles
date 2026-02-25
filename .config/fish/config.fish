# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

status is-login; and begin

    # Login shell initialisation

end

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

status is-interactive; and begin

    # Abbreviations

    # Aliases

    # Interactive shell initialisation
    begin
        set -l joined (string join " " $fish_complete_path)
        set -l prev_joined (string replace --regex "[^\s]*generated_completions.*" "" $joined)
        set -l post_joined (string replace $prev_joined "" $joined)
        set -l prev (string split " " (string trim $prev_joined))
        set -l post (string split " " (string trim $post_joined))
    end

    fish_vi_key_bindings

    direnv hook fish | source
    helmfile completion fish | source

    abbr --add k kubectl
end
