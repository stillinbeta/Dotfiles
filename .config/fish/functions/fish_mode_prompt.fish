function fish_mode_prompt
    set -l last_status $status
    switch $fish_bind_mode
        case default
            set_color --bold red
            echo '[N] '
        case insert
            if test $last_status -ne 0
                set_color --bold red
            else
                set_color --bold green
            end
            string join '' -- '[' $last_status '] '
        case replace_one replace
            set_color --bold green
            echo '[R] '
        case visual
            set_color --bold brmagenta
            echo '[V] '
        case '*'
            set_color --bold red
            echo '[?] '
    end
end
