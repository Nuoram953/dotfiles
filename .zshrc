# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# test
export PKG_CONFIG_PATH=/usr/lib/pkgconfig
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
export GOPATH='/home/nuoram/go'
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
export JIRA_API_TOKEN=''
export TERM=xterm-256color
export STARSHIP_CONFIG=~/dotfiles/starship.toml
export PATH="$PATH:/mnt/c/Windows/System32"

export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/init-nvm.sh

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_DEFAULT_OPTS='--multi --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_compgen_path() {
    fdfind --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
    fdfind --type=d --hidden --exclude .git . "$1"
}

# source ~/.env_work.sh

if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ]; then
  tmux attach || exec tmux new-session && exit;
fi

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search vi-mode fzf)

source $ZSH/oh-my-zsh.sh

source ~/.aliases
# source ~/.aliases_work


convertPath(){
    local current_directory=$(pwd)

    if [[ $current_directory == /mnt/* ]]; then
        cmd.exe /C "$@"
    else
        "$@"
    fi
}


_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
}

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$PATH:$HOME/.local/bin"
fi


function git_file_commits() {
    local file="$1"
    if [[ -z "$file" ]]; then
        echo "Please provide a file path."
        return 1
    fi

    # Use fzf to select a commit and capture the selected line
    local selected_commit=$(git log --pretty=format:"%H %s" --follow -- "$file" | fzf --preview "
        commit=\$(echo {} | awk '{print \$1}')
        echo 'Commit: ' \$commit
        echo 'Message: ' \$(git log -1 --pretty=format:\"%s\" \$commit)
        echo 'Branches:'
        git branch -r --contains \$commit
        echo 'Changes:'
        git show --stat --oneline --shortstat \$commit -- $file | tail -n 1
    " | awk '{print $1}')

    # Print the selected commit hash
    if [[ -n "$selected_commit" ]]; then
        echo "$selected_commit"
    else
        echo "No commit selected."
    fi
}

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# Source your .bashrc or .zshrc after adding the function
# source ~/.bashrc or source ~/.zshrc

bindkey -s '^s' 'tmux_last_session ^M'

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
# eval "$(_PIPENV_COMPLETE=zsh_source pipenv)" 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
