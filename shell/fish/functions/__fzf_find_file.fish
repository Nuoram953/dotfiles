function __fzf_find_file
        fd --type=d --hidden --strip-cwd-prefix \
           --exclude .git \
           --exclude node_modules \
        | fzf
    and commandline -i -- $result
    commandline -f repaint
end
