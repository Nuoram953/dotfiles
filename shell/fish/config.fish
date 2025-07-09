if status is-interactive
    # Commands to run in interactive sessions can go here
end

if type -q fzf
    bind \cr __fzf_reverse_isearch

    bind \ct __fzf_find_file

    bind \ec __fzf_cd
end

alias nv="nvim"
alias cl="clear"

set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

set -gx FZF_DEFAULT_OPTS '--height 40% --multi --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

starship init fish | source
