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

# pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# msyql 
set -x mysqlclient_cflags "-I/usr/include/mysql"
set -x smyqlclient_ldflags "-L/usr/lib -lmysqlclient"

# Uncommented when using on wsl
# set -Ux DOCKER_BUILDKIT 1
# set -x XDG_RUNTIME_DIR ~/.xdg_runtime

set -gx EDITOR 'nvim'
set -g fish_greeting ''

set -gx FZF_CD_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules"
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules"

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


pyenv init - fish | source
starship init fish | source
zoxide init fish | source
