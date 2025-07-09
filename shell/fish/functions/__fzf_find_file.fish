function __fzf_find_file
    find . -type f | fzf | read -l result
    and commandline -i -- $result
    commandline -f repaint
end
