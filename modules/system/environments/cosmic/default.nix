{ config, lib, ... }:
let
  cfg = config.modules;
in
{

  config = lib.mkIf (builtins.elem "cosmic" cfg.environments) {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the COSMIC Desktop Environment.
    services.desktopManager.cosmic = {
      enable = true;
    };
  };
}
