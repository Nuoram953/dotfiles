
SYSTEM_PACKAGES=(
  base
  base-devel
  linux
  linux-lts
  linux-headers
  linux-lts-headers
  linux-firmware
  intel-ucode
  grub
  efibootmgr
  networkmanager
  iwd
  wireless_tools
  wpa_supplicant
  ethtool
  smartmontools
  polkit-kde-agent
  pipewire
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  wireplumber
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
  xdg-user-dirs-gtk
  xdg-utils
  xorg-server
  xorg-xinit
  qt5-wayland
  qt6-wayland
  blueman
  bluez-utils
  dkms
  nvidia-dkms
  zram-generator
  pipewire
  wireplumber
)


DEV_PACKAGES=(
  cmake
  meson
  git
  vim
  nano
  kitty
  tmux
  lazygit
  fd
  fzf
  bat
  eza
  fish
  starship
  zoxide
  wget
  cpio
  openssh
  btop
  git-delta
  pyenv
  mariadb-libs
  pkgconf
  ripgrep
)


GAMING_PACKAGES=(
  gamemode
  lib32-gamemode
  gamescope-nvidia
  steam
  lutris
  protonup-qt
  opengamepadui-bin
  r2modman-bin
)


PERSONAL_PACKAGES=(
  gdm
  dolphin
  nautilus
  firefox
  qutebrowser
  zen-browser-bin
  libreoffice-still
  keepassxc
  spotify
  vesktop
  zoom
  discord
  totem
  evince
  simple-scan
  snapshot
  baobab
  malcontent
  orca
  yelp
  sushi
  loupe
  rygel
  grilo-plugins
  rofi-wayland
  waybar
  dunst
  pavucontrol
  noto-fonts
  noto-fonts-cjk
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  qutebrowser
  yazi
)

TARGET="$1"

echo "Target is: $TARGET"

if [[ "$TARGET" == "system" ]]; then
    echo "Updating the system..."
    sudo pacman -Syu --noconfirm

    echo "Installing packages..."
    sudo pacman -S --noconfirm "${SYSTEM_PACKAGES[@]}"

elif [[ "$TARGET" == "dev" ]]; then
    sudo pacman -S --noconfirm "${DEV_PACKAGES[@]}"

elif [[ "$TARGET" == "perso" ]]; then
    sudo pacman -S --noconfirm "${PERSONAL_PACKAGES[@]}"

elif [[ "$TARGET" == "gaming" ]]; then
    sudo pacman -S --noconfirm "${GAMING_PACKAGES[@]}"

else
    echo "Unknown target: $TARGET"
fi


echo "Cleaning up package cache..."
sudo pacman -Scc --noconfirm

echo "Package installation complete!"
