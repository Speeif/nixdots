{
  hostname,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.wifi;
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      hostName = hostname;
      networkmanager = {
        enable = true;
        wifi = lib.mkIf (cfg.type == "iwd") {
          backend = "iwd";
        };
      };

      wireless = lib.mkIf (cfg.type == "iwd") {
        enable = false;
        iwd.enable = true;
      };
    };
  };
}
