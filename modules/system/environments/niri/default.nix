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
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
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
