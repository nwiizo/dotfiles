function docker_tv_exec -d "Pick a running container with Television, then run a shell or command"
    type -q docker; and type -q tv; or return 1

    set -l containers (docker ps --format '{{.ID}}\t{{.Names}}\t{{.Image}}')
    or return
    test (count $containers) -gt 0; or return 0

    set -l selected (printf '%s\n' $containers | tv --inline --no-remote --no-preview \
        --input-header 'Docker exec' --keybindings 'tab="select_next_entry";backtab="select_prev_entry"')
    test $status -eq 0; or return 0
    test -n "$selected"; or return 0
    set -l container_id (string split -f 1 \t -- "$selected")
    set -q argv[1]; or set argv sh
    docker exec -it -- "$container_id" $argv
end
