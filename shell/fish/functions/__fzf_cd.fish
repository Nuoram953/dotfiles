functions -e __fzf_cd

function __fzf_cd
    set -l dir (
        fd --type=d --hidden --strip-cwd-prefix \
           --exclude .git \
           --exclude node_modules \
        | fzf
    )

    test -n "$dir"; and cd "$dir"
end
