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
