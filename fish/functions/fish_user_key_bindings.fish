function fish_user_key_bindings
    if functions -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --history= --git_log= --git_status= --processes= --variables=
    end

    # fzf removes its old Ctrl-R binding, including Atuin's later replacement.
    if functions -q _atuin_search
        bind ctrl-r _atuin_search
        bind -M insert ctrl-r _atuin_search
    end

    bind alt-j git_fzf_ghq
    bind ctrl-g git_fzf_ghq
    bind ctrl-b git_fzf_branch
    bind ctrl-l clear-screen
    bind tab __history_tab_complete
end
