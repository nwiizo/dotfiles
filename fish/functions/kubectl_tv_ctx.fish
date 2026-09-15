function kubectl_tv_ctx -d "Pick a Kubernetes context with Television, then switch"
    type -q kubectl; and type -q tv; or return 1

    set -l contexts (kubectl config get-contexts -o name)
    or return
    test (count $contexts) -gt 0; or return 0

    set -l selected (printf '%s\n' $contexts | tv --inline --no-remote --no-preview \
        --input-header 'Kubernetes context' --keybindings 'tab="select_next_entry";backtab="select_prev_entry"')
    test $status -eq 0; or return 0
    test -n "$selected"; or return 0
    kubectl config use-context -- "$selected"
end
