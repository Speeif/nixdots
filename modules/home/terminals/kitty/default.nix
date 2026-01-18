{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.terminal;
  font = config.font;
in
{
  config = lib.mkIf (cfg.name == "kitty") {
    programs.kitty = {
      enable = true;
      package = pkgs.kitty;
      font = "${font}";
      settings = {
        confirm_os_window_close = 0; # diable check
        # dynamic_background_opacity = true;
        enable_audio_bell = false;
        mouse_hide_wait = "-1.0";
        window_padding_width = 5;

        ## Due to the blur not working (I don't wanna debug)
        ## I have disabled it fully.
        # background_opacity = "0.2";
        # background_blur = 5;
      };
    };
  };
}
