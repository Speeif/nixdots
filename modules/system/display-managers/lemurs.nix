{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.displayManager.lemurs;
in
{
  config = lib.mkIf cfg.enable {
    services.displayManager.lemurs = {
      enable = true;
      package = pkgs.lemurs;
    };
  };
}
