{
  self,
  ...
}:
let
  inherit (self) theme;
in
{
  flake.nixosModules."ly" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      selectedAnimation = config.displayManagers.ly.animation;
    in
    {
      options = with lib; {
        displayManagers.ly = {
          animation = mkOption {
            type = types.enum [
              "doom"
              "matrix"
              "colormix"
              "gameoflife"
              "none"
            ];
            default = "none";
            description = "Background theme of the ly displayManager";
          };
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          brightnessctl
        ];
        services.displayManager.ly = {
          enable = true;
          package = pkgs.ly; # TUI -- zig -- https://codeberg.org/AnErrupTion/ly
          x11Support = true;
          settings = {
            # [config]
            lang = "en";
            service_name = "ly";
            allow_empty_password = false;
            clear_password = true; # on failure
            auth_fails = 3; # display animation at X
            default_input = "password";
            inactive_command = null;

            # [information bars]
            hide_key_hints = false;
            hide_keyboard_lock = false;
            hide_version_string = true;

            # [animation]
            animation = selectedAnimation;
            animation_timeout_sec = 20; # run for X seconds
            # [animation:colormix]
            colormix_col1 = "0x00${theme.base09}"; # peach
            colormix_col2 = "0x00${theme.base0C}"; # teal
            colormix_col3 = "0x00${theme.base0E}"; # mauve

            # [styling]
            bg = "0x00${theme.base00}";
            fg = "0x00${theme.base02}";
            error_bg = "0x00000000";
            error_fg = "0x00FF0000";

            # [box]
            hide_borders = false;
            blank_box = true;
            border_fg = "0x00${theme.base08}";

            # [functions]
            restart_cmd = "/run/current-system/sw/bin/shutdown -r now";
            restart_key = "F11";
            shutdown_cmd = "/run/current-system/sw/bin/shutdown -h now";
            shutdown_key = "F12";
            sleep_cmd = null;
            sleep_key = "F10";

            brightness_down_key = "F2";
            brightness_down_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q -n -s 10%-";
            brightness_up_key = "F3";
            brightness_up_cmd = "${pkgs.brightnessctl}/bin/brightnessctl -q -n -s 10%+";
          };
        };
      };
    };
}
