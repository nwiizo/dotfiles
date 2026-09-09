function docker_fzf_exec -d "Pick a running container with fzf, then run a shell or command"
    type -q docker; and type -q fzf; or return 1

    set -l containers (docker ps --format '{{.ID}}\t{{.Names}}\t{{.Image}}')
    or return
    test (count $containers) -gt 0; or return 0

    set -l selected (printf '%s\n' $containers | fzf --no-multi --prompt='docker exec> ')
    test -n "$selected"; or return 0
    set -l container_id (string split -f 1 \t -- "$selected")
    set -q argv[1]; or set argv sh
    docker exec -it -- "$container_id" $argv
end
