function imgcopy --description 'Copy a JPEG or PNG image to the macOS clipboard'
    if test (count $argv) -eq 1; and contains -- "$argv[1]" -h --help
        echo 'usage: imgcopy IMAGE (JPEG or PNG)'
        return 0
    end

    if test (count $argv) -ne 1
        echo 'usage: imgcopy IMAGE (JPEG or PNG)' >&2
        return 2
    end

    set -l image_path (path resolve -- "$argv[1]"); or return 1
    if not test -f "$image_path"; or not test -r "$image_path"
        printf 'imgcopy: not a readable file: %s\n' "$argv[1]" >&2
        return 1
    end

    set -l image_type (command file --brief --mime-type -- "$image_path"); or return 1
    set -l image_class
    switch "$image_type"
        case image/jpeg
            set image_class 'JPEG picture'
        case image/png
            set image_class '«class PNGf»'
        case '*'
            printf 'imgcopy: unsupported image type: %s (use JPEG or PNG)\n' "$image_type" >&2
            return 1
    end

    command osascript \
        -e 'on run argv' \
        -e "set the clipboard to (read (POSIX file (item 1 of argv)) as $image_class)" \
        -e 'end run' \
        "$image_path"
end
