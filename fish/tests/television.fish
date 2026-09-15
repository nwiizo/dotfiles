# Run: fish --no-config fish/tests/television.fish
set -l repo_root (path resolve (status dirname)/../..)
set -p fish_function_path $repo_root/fish/functions

function fail -a message
    echo "FAIL: $message" >&2
    exit 1
end

function commandline
    if contains -- --replace $argv
        set -g test_inserted $argv[-1]
    else if contains -- --current-token $argv
        printf '%s' "$test_query"
    else if contains -- --current-process $argv; or contains -- --current-buffer $argv
        printf '%s' "$test_buffer"
    end
end

function tv
    set -g test_tv_args $argv
    printf '%s' "$test_selection"
    return $test_status
end

function history
    if contains -- merge $argv
        set -g test_history_merged 1
        return
    end
    printf 'one\0begin\n echo two\nend\0'
end

set -g test_status 0
set -g test_query ''
set -g test_buffer 'cat '
set -g test_selection "a 'quoted' file.txt"
__tv_complete files
test "$test_inserted" = (string escape -- "$test_selection")' '; or fail 'file quoting'

set -g test_buffer ''
__tv_complete
test "$test_tv_args[2]" = ''; or fail 'empty command completion argument'
set -g test_buffer 'cat '

set -g test_query "$repo_root/"
set -g test_selection README.md
__tv_complete paths
test "$test_inserted" = (string escape -- "$repo_root/README.md")' '; or fail 'directory search prefix'
set -g test_query '$fish_col'
set -g test_selection fish_color_normal
__tv_variables
test "$test_inserted" = '$fish_color_normal'; or fail 'variable dollar prefix'
set -g test_query ''

set -g test_selection "begin
 echo two
end"
set -g fish_private_mode ''
__tv_history
test "$test_inserted" = "$test_selection"; or fail 'multiline history'
set -q test_history_merged; or fail 'history from other sessions was not merged'
set -e test_history_merged
set -g fish_private_mode 1
__tv_history
set -q test_history_merged; and fail 'private history was merged'
set -e fish_private_mode

set -g test_status 130
set -g test_selection ''
set -g test_inserted unchanged
__tv_history
__tv_complete files
test "$test_inserted" = unchanged; or fail 'cancel changed the command'

function git
    if test "$argv[1]" = for-each-ref
        echo feature/test
    else
        set -g test_mutation $argv
    end
end
function kubectl
    if test "$argv[2]" = get-contexts
        echo staging
    else
        set -g test_mutation $argv
    end
end
function docker
    if test "$argv[1]" = ps
        printf 'abc123\tapp\timage\n'
    else
        set -g test_mutation $argv
    end
end

set -e test_mutation
git_tv_branch
kubectl_tv_ctx
docker_tv_exec
set -q test_mutation; and fail 'cancel performed an operation'
set -g test_status 0
set -g test_selection feature/test
git_tv_branch
test "$test_mutation" = 'switch -- feature/test'; or fail 'branch switch arguments'
set -g test_selection staging
kubectl_tv_ctx
test "$test_mutation" = 'config use-context -- staging'; or fail 'context arguments'
set -g test_selection (printf 'abc123\tapp\timage')
docker_tv_exec printf '%s' 'two words'
test "$test_mutation[4]" = abc123; or fail 'container identity'
test "$test_mutation[-1]" = 'two words'; or fail 'container command quoting'

function zoxide
    printf '%s\n' $PWD
end
function __zoxide_cd
    builtin cd $argv
end
set -g test_status 130
set -g test_selection /tmp
set -l original_pwd $PWD
zi
test "$PWD" = "$original_pwd"; or fail 'failed directory picker changed cwd'
set -g test_status 0

# Exercise the real Television parser and bat preview with an apostrophe in the path.
functions --erase tv
function tv
    command tv $argv --take-1
end
function history
    contains -- merge $argv; and return
    printf '09-15 12:00:00 │ begin\n echo "two words"\nend\0'
end
set -g test_buffer ''
__tv_history
test "$test_inserted" = 'begin
 echo "two words"
end'; or fail 'real history timestamps or multiline output'
functions --erase tv
function tv
    set -l preview_index (contains --index -- --preview-command $argv)
    set -l preview $argv[(math $preview_index + 1)]
    set -l command (printf '%s\0' "$test_preview_entry" | command tv --source-entry-delimiter '\0' --source-output "$preview" --take-1 | string collect)
    set -g test_preview_output (bash -c "$command" | string collect)
    printf '%s\n' "$test_preview_entry"
end
set -g test_preview_entry '09-15 12:00:00 │ begin
 echo "a '\''quoted'\'' command"
end'
__tv_history
string match -q '*quoted*' -- "$test_preview_output"; or fail 'full history preview with quotes'

set -l variable_fixture (mktemp -d)
printf '$tv_fixture: set in local scope, unexported, with 2 elements\n$tv_fixture[1]: |one|\n$tv_fixture[2]: |two words|\n' >"$variable_fixture/details"
printf 'tv_fixture\n' >"$variable_fixture/names"
set -g test_preview_entry tv_fixture
__tv_variables "$variable_fixture/details" "$variable_fixture/names"
rm -r -- "$variable_fixture"
string match -q '*local scope*two words*' -- "$test_preview_output"; or fail 'variable scope and complete value preview'
functions --erase tv
set -l fixture (mktemp -d)
set -l sample "$fixture/a 'quoted' file.txt"
printf 'preview-marker\n' >"$sample"
set -l template (yq -p toml -oy -r '.preview.command' $repo_root/television/cable/files.toml)
set -l preview (printf '%s\n' "$sample" | command tv --source-output "$template" --take-1)
set -l rendered (bash -c "$preview" | string collect)
rm -r -- "$fixture"
string match -q '*preview-marker*' -- "$rendered"; or fail 'literal path preview'

echo television-fish-ok
