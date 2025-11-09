#!/usr/bin/env bash
set -e

read -rp "Enter the new username: " USERNAME

if [[ -z "$USERNAME" ]]; then
    echo "No username entered. Exiting."
    exit 1
fi

if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists, skipping creation."
else
    echo "Creating user '$USERNAME'..."
    useradd -m -G wheel -s /bin/bash "$USERNAME"

    echo "Set password for $USERNAME:"
    passwd "$USERNAME"

    echo "User '$USERNAME' created and added to wheel group."
fi

if ! command -v sudo &>/dev/null; then
    echo "Installing sudo..."
    pacman -Sy --noconfirm sudo
fi

if ! grep -Eq '^%wheel\s+ALL=\(ALL:ALL\)\s+ALL' /etc/sudoers; then
    echo "Enabling wheel group for sudo..."
    echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers
fi

echo "Setup complete for user '$USERNAME'."
