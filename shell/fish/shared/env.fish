set -Ux TERM xterm-256color

# Default editor everywhere
set -gx EDITOR nvim

# Disable Fish greeting globally
set -g fish_greeting ''

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

# pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
fish_add_path $PYENV_ROOT/bin

# composer
fish_add_path ~/.config/composer/vendor/bin

# local user bin
fish_add_path ~/.local/bin

# mysql
set -gx mysqlclient_cflags "-I/usr/include/mysql"
set -gx mysqlclient_ldflags "-L/usr/lib -lmysqlclient"
