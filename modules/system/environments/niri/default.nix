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

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
      xwayland-satellite
      tokyonight-gtk-theme
      swayimg
      rose-pine-cursor
      pkgs.adwaita-icon-theme
      nemo
      fuzzel
      gpu-screen-recorder
    ];

    services.greetd = {
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
          user = "speeif";
        };

        initial_session = {
          command = "niri-session";
          user = "speeif";
        };
      };
    };
  };
}
