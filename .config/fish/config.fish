# Only execute this file once per shell.
set -q __fish_home_manager_config_sourced; and exit
set -g __fish_home_manager_config_sourced 1

status is-login; and begin

    # Login shell initialisation

end

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

end
