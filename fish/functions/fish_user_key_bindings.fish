function fish_user_key_bindings
    if type -q tv
        bind ctrl-t __tv_complete
        bind ctrl-f '__tv_complete paths'
        bind ctrl-r __tv_history
        bind ctrl-alt-l '__tv_complete git-log'
        bind ctrl-alt-s '__tv_complete git-diff'
        bind ctrl-alt-p '__tv_complete processes'
    end

    bind alt-j git_tv_ghq
    bind ctrl-g git_tv_ghq
    bind ctrl-b git_tv_branch
    bind ctrl-l clear-screen
    bind tab __history_tab_complete
end
