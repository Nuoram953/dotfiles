source ~/.config/fish/shared/env.fish
source ~/.config/fish/shared/tools.fish
source ~/.config/fish/shared/fzf.fish
source ~/.config/fish/shared/aliases.fish
source ~/.config/fish/shared/keymaps.fish

if test -f ~/.config/fish/local/config.local.fish
    source ~/.config/fish/local/config.local.fish
end

set -q PROFILE; or set -gx PROFILE $hostname

switch $PROFILE
    case machine
        source ~/.config/fish/profiles/personal.fish
    case '*'
        source ~/.config/fish/profiles/work.fish
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

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

