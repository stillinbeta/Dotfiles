function fish_right_prompt
    if not contains -- --final-rendering $argv
        string join '' (prompt_pwd) (fish_vcs_prompt)
    end
end
