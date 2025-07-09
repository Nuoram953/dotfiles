function __fzf_cd
    find . -type d | fzf | read -l result
    and cd $result
    commandline -f repaint
end
