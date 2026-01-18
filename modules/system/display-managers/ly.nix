{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.displayManager.ly;
in
{
  config = lib.mkIf cfg.enable {
    services.displayManager.ly = {
      enable = true;
      package = pkgs.ly; # TUI -- zig -- https://codeberg.org/AnErrupTion/ly
      x11Support = true;
      settings = {
        # === behaviour ===
        lang = "en";
        load = true;
        numlock = false;
        save = true;
        text_in_center = false; # ugly
        clear_password = true;
        auth_fails = 3; # special animation looks broken?
        # allow_empty_password = false; # dangerous?
        hide_key_hints = true;
        # input_len = 69;

        # === components ===
        hide_version_string = true;
        fg = "0x01FFFFFF";

        # [center_box]
        hide_borders = false;
        margin_box_h = 2;
        margin_box_v = 4;
        # blank_box = false; # transparent
        box_title = "null"; # text above the box
        border_fg = "0x01FFFFFF";
        error_bg = "0x02000000";
        error_fg = "0x01FF0000";

        initial_info_text = "null"; # hostname
        default_input = "password";

        # [clock]
        clock = "%B, %A %d @ %H:%M:%S";
        # bigclock = "en"; # enlarges the clock -- may not work with some fonts?

        # [background]
        bg = "0x02000000";
        animation = "${cfg.theme}";
        animation_timeout_sec = 300; # 5 minutes
        colormix_col1 = "0x08FF0000";
        colormix_col2 = "0x0800FF00";
        colormix_col3 = "0x080000FF";
        min_refresh_delta = 10; # milliseconds -- default=5
        # tty = 4; # broken? -- could help with UWSM sessions
      };
    };
  };
}
