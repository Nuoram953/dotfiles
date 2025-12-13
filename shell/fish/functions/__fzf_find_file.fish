function __fzf_find_file
    set -l result (
        fd --type=f --hidden --strip-cwd-prefix \
           --exclude .git \
           --exclude node_modules \
        | fzf
    )

    if test -n "$result"
        commandline -i -- $result
        commandline -f repaint
    end
end
