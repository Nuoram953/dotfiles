#!/bin/bash


#####################################################################################################
#PACKAGES
#####################################################################################################

echo "Updating the system..."
sudo pacman -Syu --noconfirm

PACKAGES=(
  ags-hyprpanel-git
  baobab
  base
  base-devel
  bat
  blueman
  bluez-utils
  btop
  cmake
  cpio
  discord
  dkms
  dolphin
  dunst
  efibootmgr
  epiphany
  ethtool
  evince
  eza
  fd
  firefox
  fzf
  gamemode
  gamescope-nvidia
  gdm
  git
  grilo-plugins
  grim
  grub
  gst-plugin-pipewire
  gvfs
  gvfs-afc
  gvfs-dnssd
  gvfs-goa
  gvfs-google
  gvfs-gphoto2
  gvfs-mtp
  gvfs-nfs
  gvfs-onedrive
  gvfs-smb
  gvfs-wsdd
  hyprland
  hyprlock
  hyprpaper
  intel-ucode
  iwd
  keepassxc
  kitty
  lazygit
  lib32-gamemode
  libpulse
  libreoffice-still
  linux
  linux-firmware
  linux-headers
  linux-lts
  linux-lts-headers
  loupe
  lutris
  malcontent
  meson
  nano
  nautilus
  neovim
  networkmanager
  noto-fonts
  noto-fonts-cjk
  nvidia-dkms
  opengamepadui-bin
  openssh
  orca
  pavucontrol
  pipewire
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  polkit-kde-agent
  protonup-qt
  qt5-wayland
  qt6-wayland
  qutebrowser
  r2modman-bin
  rofi-wayland
  rygel
  simple-scan
  slurp
  smartmontools
  snapshot
  spotify
  starship
  steam
  sushi
  tecla
  tmux
  totem
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  vesktop
  vim
  waybar
  wget
  wine
  winetricks
  wireless_tools
  wireplumber
  wofi
  wpa_supplicant
  xdg-desktop-portal-gnome
  xdg-desktop-portal-hyprland
  xdg-user-dirs-gtk
  xdg-utils
  xorg-server
  xorg-xinit
  yay
  yay-debug
  yazi
  yelp
  zen-browser-bin
  zoom
  zoxide
  zram-generator
  zsh
)

echo "Installing packages..."
sudo pacman -S --noconfirm "${PACKAGES[@]}"

echo "Cleaning up package cache..."
sudo pacman -Scc --noconfirm

echo "Package installation complete!"

#####################################################################################################
#NVIDIA
#####################################################################################################
echo "Creating pacman hook for NVIDIA driver..."

HOOK_PATH="/etc/pacman.d/hooks/nvidia.hook"

if [ ! -f "$HOOK_PATH" ]; then
    sudo cp "$(dirname "$0")/nvidia.hook" "$HOOK_PATH"
    echo "NVIDIA pacman hook created successfully!"
else
    echo "NVIDIA pacman hook already exists."
fi

MKINITCPIO_CONF="/etc/mkinitcpio.conf"
if ! grep -q "nvidia" "$MKINITCPIO_CONF"; then
    echo "Enabling NVIDIA modules in mkinitcpio.conf..."
    sudo sed -i 's/MODULES=(.*)/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' "$MKINITCPIO_CONF"
else
    echo "NVIDIA modules already present in mkinitcpio.conf."
fi

MODPROBE_CONF="/etc/modprobe.d/nvidia.conf"
if [ ! -f "$MODPROBE_CONF" ]; then
    echo "Creating /etc/modprobe.d/nvidia.conf..."
    echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee "$MODPROBE_CONF" > /dev/null
else
    echo "/etc/modprobe.d/nvidia.conf already exists."
fi

echo "Rebuilding initramfs..."
sudo mkinitcpio -P

echo "NVIDIA Kernel Mode Setting enabled successfully. Please reboot your system to apply the changes."


#####################################################################################################
#DOWNLOADING GIT REPOS
#####################################################################################################

REPOS=(
  "https://github.com/tmux-plugins/tpm.git:/$HOME/.tmux/plugins/tpm"
  "https://github.com/zsh-users/zsh-autosuggestions.git:/$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git:/$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  "https://github.com/jeffreytse/zsh-vi-mode.git:/$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode"
)

for repo in "${REPOS[@]}"; do
  IFS=":" read -r REPO_URL TARGET_DIR <<< "$repo"

  if [ -d "$TARGET_DIR" ]; then
    echo "Target directory '$TARGET_DIR' already exists. Skipping..."
  else
    echo "Cloning '$REPO_URL' into '$TARGET_DIR'..."
    git clone "$REPO_URL" "$TARGET_DIR"
    if [ $? -eq 0 ]; then
      echo "Successfully cloned '$REPO_URL'."
    else
      echo "Failed to clone '$REPO_URL'."
    fi
  fi
done


#####################################################################################################
#OH MY ZSH
#####################################################################################################
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#####################################################################################################
#CREATING SYMLINKS
#####################################################################################################

SYMLINKS=(
  "$HOME/dotfiles/.config/nvim:$HOME/.config/nvim"
  "$HOME/dotfiles/.tmux.conf:$HOME/.tmux.conf"
  "$HOME/dotfiles/.config/hypr:$HOME/.config/hypr"
  "$HOME/dotfiles/.config/hyprpanel:$HOME/.config/hyprpanel"
  "$HOME/dotfiles/.config/yazi:$HOME/.config/yazi"
  "$HOME/dotfiles/.config/lazygit:$HOME/.config/lazygit"
  "$HOME/dotfiles/.aliases:$HOME/.aliases"
  "$HOME/dotfiles/.zshrc:$HOME/.zshrc"
  "$HOME/dotfiles/.config/kitty:$HOME/.config/kitty"

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

chsh -s $(which zsh)
