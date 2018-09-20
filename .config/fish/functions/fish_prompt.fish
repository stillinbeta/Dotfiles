function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -l suffix
    switch "$USER"
        case root toor
            set suffix '#'
        case '*'
            set suffix '$'
    end

    if not test $last_status -eq 0
        echo -n (set_color $fish_color_error)"$last_status "(set_color normal)
    else
        echo -n "$suffix "
    end

end

function fish_right_prompt --description "Write out the right prompt"
	  set -l color_cwd
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
        case '*'
            set color_cwd $fish_color_cwd
    end
    printf '%s ' (__fish_vcs_prompt)
    echo -n -s (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
    if test $CMD_DURATION; and test $CMD_DURATION -gt 1000
        # Show duration of the last command in seconds
        set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
        echo -n $duration
    end
end
