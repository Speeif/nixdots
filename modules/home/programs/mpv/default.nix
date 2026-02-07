{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.programs.mpv;
in
{
  config = lib.mkIf cfg.enable {

    programs.mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.mpris ];
    };

  };
}
