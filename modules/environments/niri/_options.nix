{ lib, ... }:
{
  niri-commands = with lib; {
    bar = {
      start = mkOption {
        type = types.str;
        default = "";
      };
      stop = mkOption {
        type = types.str;
        default = "";
      };
      restart = mkOption {
        type = types.str;
        default = "";
      };
      debug = mkOption {
        type = types.str;
        default = "";
      };
    };
  };
}
