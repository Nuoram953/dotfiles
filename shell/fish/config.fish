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

set -gx FZF_DEFAULT_OPTS '--multi --color=fg:#839496,bg:#002b36,hl:#268bd2 --color=fg+:#fdf6e3,bg+:#073642,hl+:#268bd2 --color=info:#93a1a1,prompt:#b58900,pointer:#d33682 --color=marker:#cb4b16,spinner:#2aa198,header:#586e75'

if set -q TMUX
    if not set -q IS_TMUX_POPUP
        if status is-interactive
            if not set -q FASTFETCH_SHOWN
                set -gx FASTFETCH_SHOWN 1
                fastfetch
            end
        end
    end
end

starship init fish | source
zoxide init fish | source
