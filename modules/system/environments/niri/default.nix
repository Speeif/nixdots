{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
let
  cfg = config.modules;
in
{
  config = lib.mkIf (builtins.elem "niri" cfg.environments) {
    programs.niri.enable = true;
    # programs.quickshell.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      tokyonight-gtk-theme
      swayimg
      rose-pine-cursor
      adwaita-icon-theme
      nautilus
      fuzzel
      gpu-screen-recorder
    ];
  };
}
