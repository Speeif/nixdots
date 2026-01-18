{ config, lib, ... }:
let
  cfg = config.modules;
in
{

  config = lib.mkIf (builtins.elem "gnome" cfg.environments) {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.desktopManager.gnome.enable = true;
  };
}
