# WSL related env
set -Ux DOCKER_BUILDKIT 1
set -x XDG_RUNTIME_DIR ~/.xdg_runtime
set -U fish_user_paths /mnt/c/Windows/System32/WindowsPowerShell/v1.0 $fish_user_paths
set -U fish_user_paths /mnt/c/Windows/System32/ $fish_user_paths
