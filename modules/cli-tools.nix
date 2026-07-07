{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    bat
    wget
    delta
  ];
}
