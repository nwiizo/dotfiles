function fish_user_key_bindings
    if functions -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --history= --git_log= --git_status= --processes= --variables=
    end

    bind ctrl-g ghq_fzf_repo
    bind \ej jj_fzf_ghq
    bind ctrl-b git_fzf_branch
    bind ctrl-l 'clear; commandline -f repaint'
    bind \t __history_tab_complete
end
