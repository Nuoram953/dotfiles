{ pkgs, ... }:
{
  home.packages = with pkgs; [
    _0xproto
  ];

  fonts.fontconfig.enable = true;
}
