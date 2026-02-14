{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.docker;
in
{
  config = lib.mkIf cfg {
    programs.docker-cli.enable = true;
  };
}
