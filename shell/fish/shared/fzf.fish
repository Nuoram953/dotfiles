if type -q fzf

    bind \cr __fzf_reverse_isearch
    bind \ct __fzf_find_file
    bind \ec __fzf_cd

    if type -q fd
        set -gx FZF_DEFAULT_COMMAND \
            fd \
            --hidden \
            --strip-cwd-prefix \
            --exclude .git

        set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

        set -gx FZF_CD_COMMAND \
            fd \
            --type=d \
            --hidden \
            --strip-cwd-prefix \
            --exclude .git \
            --exclude node_modules

        set -gx FZF_ALT_C_COMMAND \
            fd \
            --type=d \
            --hidden \
            --strip-cwd-prefix \
            --exclude .git \
            --exclude node_modules
    end

    set -l fzf_opts \
        --style full \
        --multi \
        --height 40% \
        --color=fg:#839496 \
        --color=bg:#002b36 \
        --color=hl:#268bd2 \
        --color=fg+:#fdf6e3 \
        --color=bg+:#073642 \
        --color=hl+:#268bd2 \
        --color=info:#93a1a1 \
        --color=prompt:#b58900 \
        --color=pointer:#d33682 \
        --color=marker:#cb4b16 \
        --color=spinner:#2aa198 \
        --color=header:#586e75

    set -gx FZF_DEFAULT_OPTS (string join " " -- $fzf_opts)

end
