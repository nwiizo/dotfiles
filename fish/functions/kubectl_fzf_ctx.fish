function kubectl_fzf_ctx -d "Pick a Kubernetes context with fzf, then switch"
    type -q kubectl; and type -q fzf; or return 1

    set -l contexts (kubectl config get-contexts -o name)
    or return
    test (count $contexts) -gt 0; or return 0

    set -l selected (printf '%s\n' $contexts | fzf --no-multi --prompt='kube context> ')
    test -n "$selected"; or return 0
    kubectl config use-context -- "$selected"
end
