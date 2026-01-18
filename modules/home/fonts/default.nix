{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.fonts;
in
{
  config = lib.mkIf (cfg.enable) {
    home.packages = cfg.packages;
    fonts.fontconfig = {
      enable = true;
      defaultFonts = cfg.defaultFonts;
    };
  };
}
