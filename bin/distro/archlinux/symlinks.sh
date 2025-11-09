SYMLINKS=(
  "$HOME/dotfiles/.config/nvim:$HOME/.config/nvim"
  "$HOME/dotfiles/.tmux.conf:$HOME/.tmux.conf"
  "$HOME/dotfiles/.config/hypr:$HOME/.config/hypr"
  "$HOME/dotfiles/.config/hyprpanel:$HOME/.config/hyprpanel"
  "$HOME/dotfiles/.config/yazi:$HOME/.config/yazi"
  "$HOME/dotfiles/.config/lazygit:$HOME/.config/lazygit"
  "$HOME/dotfiles/.aliases:$HOME/.aliases"
  "$HOME/dotfiles/starship.toml:$HOME/.config/starship.toml"
  "$HOME/dotfiles/shell/fish:$HOME/.config/fish"
  "$HOME/dotfiles/terminal/kitty/:$HOME/.config/kitty"
  "$HOME/dotfiles/fastfetch/:$HOME/.config/fastfetch"
  "$HOME/dotfiles/waybar/:$HOME/.config/waybar"
  "$HOME/dotfiles/niri/:$HOME/.config/niri"
)

for link in "${SYMLINKS[@]}"; do
  IFS=":" read -r SOURCE TARGET <<< "$link"

  if [ ! -e "$SOURCE" ]; then
    echo "Source '$SOURCE' does not exist. Creating it..."
    if [[ "$SOURCE" == */ ]]; then
      mkdir -p "$SOURCE"
      echo "Created directory: $SOURCE"
    else
      touch "$SOURCE"
      echo "Created file: $SOURCE"
    fi
  fi

  if [ -e "$TARGET" ]; then
    echo "Target '$TARGET' already exists. Skipping..."
  else
    echo "Creating symlink from '$SOURCE' to '$TARGET'..."
    ln -s "$SOURCE" "$TARGET"
    if [ $? -eq 0 ]; then
      echo "Successfully created symlink: $TARGET -> $SOURCE"
    else
      echo "Failed to create symlink: $TARGET -> $SOURCE"
    fi
  fi
done

