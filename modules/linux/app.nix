# modules/linux/apps.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    grim
  ];
}
