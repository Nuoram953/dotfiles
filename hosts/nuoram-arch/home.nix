{ pkgs, ... }:
{
  imports = [
    ../../modules
    ../../modules/linux
  ];

  home.username = "nuoram";
  home.homeDirectory = "/home/nuoram";
  home.stateVersion = "24.05";

  features.emulators.enable = false;

  programs.home-manager.enable = true;

  programs.git.settings.user.email = "antoinemaroun@gmail.com";

  # home.file.".config/hypr/hyprland.conf".source = ../../config/hypr/hyprland.conf;
}
