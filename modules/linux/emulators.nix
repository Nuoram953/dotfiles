{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.emulators.enable = mkEnableOption "emulator packages";

  config = mkIf config.features.emulators.enable {
    home.packages = with pkgs; [
      retroarch
      dolphin-emu
      pcsx2
    ];
  };
}
