function __fzf_reverse_isearch
    history merge
    history | fzf --tiebreak=index | read -l result
    and commandline -- $result
    commandline -f repaint
end
