{
  self,
  inputs,
  ...
}: let
  moduleName = "niri";
in {
  flake.nixosModules."${moduleName}" = {
    pkgs,
    config,
    ...
  }: {
    security.polkit.enable = true; # polkit
    environment.systemPackages = with pkgs; [
    ];
    programs.niri = {
      enable = true;
      package = self.packages."${pkgs.stdenv.hostPlatform.system}"."${moduleName}";
    };
  };

  perSystem = {
    pkgs,
    config,
    lib,
    self',
    ...
  }: {
    packages."${moduleName}" = inputs.wrapperModules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        prefer-no-csd = true;
        input = {
          keyboard = {
            xkb.layout = "dk";
            numlock = _: {};
          };

          touchpad = {
            tap = _: {};
            natural-scroll = _: {};
          };

          warp-mouse-to-focus = _: {};
          focus-follows-mouse = _: {
            props = {
              max-scroll-amount = "0%";
            };
          };
        };

        spawn-at-startup = [
          (lib.getExe pkgs.kitty)
          (lib.getExe pkgs.kitty)
          (lib.getExe pkgs.mako)
          (lib.getExe self'.packages."niri-waybar")
        ];

        layout = {
          gaps = 6;
          # one of [ "never" "always" "on-overflow" ]
          center-focused-column = "never";
          # default values kept <3
          preset-column-widths = [
            {proportion = 0.33;}
            {proportion = 0.5;}
            {proportion = 0.66;}
          ];

          default-column-width = {
            proportion = 0.5;
          };

          focus-ring = {
            width = 6;
            active-color = self.themeHashed.base0D;
            inactive-color = self.themeHashed.base03;
          };

          border = {
            off = _: {};
          };

          # Screen padding (if 2 columns, then either side has padding)
          struts = {
            # left = 12;
          };
        };

        animations = {
          # off = _:{}; # turns off animations
          # values below 1 speed up, value above, slow down
          slowdown = 1;
        };

        # Internally the module uses the toKdl function from
        # wrapper modules input, and therefore can use the
        # custom bindings defined here:
        # https://birdeehub.github.io/nix-wrapper-modules/lib/wlib.html?highlight=_%3A%20%7B#function-library-wlib.toKdl

        # Short guide, for the implementation of this pattern..
        # NIX: `"Mod+Q".close-window = _: { };`
        # KDL: `Mod+Q { close-window; }`

        # NIX:
        # "Mod+Q"= _: {
        #   props = { repeat = false; };
        #   content = { close-window = _:{ }; };
        # };
        # KDL: `Mod+Q repeat=false { close-window; }

        # NIX:
        # "XF86AudioRaiseVolume" = _: {
        #   props = { allow-when-locked = true; };
        #   content = { spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; };
        # };
        # KDL: XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
        binds = let
          mkNoRepeat = content: _: {
            props = {
              repeat = false;
            };
            inherit content;
          };
          mkAllowedWhenLocked = content: _: {
            props = {
              allow-when-locked = true;
            };
            inherit content;
          };
          # applications
          wpctl = lib.getExe' pkgs.wireplumber "wpctl";
          playerctl = lib.getExe pkgs.playerctl;
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in
          lib.mkMerge [
            # ##### applications ##### #
            {
              "Mod+T" = _: {
                props = {
                  repeat = false;
                  hotkey-overlay-title = "Open terminal: Kitty";
                };
                content = {
                  spawn-sh = lib.getExe pkgs.kitty;
                };
              };
              "Mod+A" = _: {
                props = {
                  repeat = false;
                  hotkey-overlay-title = "Application launcher: Fuzzed";
                };
                content = {
                  spawn-sh = lib.getExe self'.packages."niri-fuzzel";
                };
              };
              "Mod+B" = _: let
                pkill = lib.getExe' pkgs.procps "pkill";
                waybar = lib.getExe self'.packages."niri-waybar";
                start = "exec ${waybar} &";
                stop = "${pkill} -f ${waybar} >/dev/null";
                launcher = self.mkWhichKey pkgs [
                  {
                    key = "1";
                    desc = "Start";
                    cmd = "${start}";
                  }
                  {
                    key = "2";
                    desc = "kill";
                    cmd = "${stop}";
                  }
                  {
                    key = "3";
                    desc = "Debug";
                    cmd = "GTK_DEBUG=interactive ${start}";
                  }
                ];
              in {
                props = {
                  repeat = false;
                  hotkey-overlay-title = "Waybar options";
                };
                content = {
                  spawn-sh = lib.getExe launcher;
                };
              };

              "Shift+Mod+Print" = _: {
                props = {
                  hotkey-overlay-title = "Take screenshot";
                };
                content = let
                  grim = lib.getExe pkgs.grim;
                  wlCopy = lib.getExe' pkgs.wl-clipboard "wl-copy";
                in {
                  spawn-sh = "${grim} -l 0 - | ${wlCopy}";
                };
              };

              "Print" = _: {
                props = {
                  hotkey-overlay-title = "Screenshot manager";
                };
                content = let
                  grim = lib.getExe pkgs.grim;
                  wlCopy = lib.getExe' pkgs.wl-clipboard "wl-copy";
                  slurp = lib.getExe pkgs.slurp;
                  launcher = self.mkWhichKey pkgs [
                    {
                      key = "1";
                      desc = "Boundery";
                      cmd = "${grim} -g $(${slurp}) - | ${wlCopy}";
                    }
                    {
                      key = "2";
                      desc = "Fullscreen";
                      cmd = "${grim} -l 0 - | ${wlCopy}";
                    }
                  ];
                in {
                  spawn-sh = lib.getExe launcher;
                };
              };

              "Mod+Q" = mkNoRepeat {
                close-window = _: {};
              };
            }
            # SCREENSHOTS
            {
            }
            # media keybinds
            {
              "XF86AudioRaiseVolume" = mkAllowedWhenLocked {
                spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
              };

              "XF86AudioLowerVolume" = mkAllowedWhenLocked {
                spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              };

              "XF86AudioMute" = mkAllowedWhenLocked {
                spawn-sh = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };

              "XF86AudioMicMute" = mkAllowedWhenLocked {
                spawn-sh = "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              };

              "XF86AudioPlay" = mkAllowedWhenLocked {
                spawn-sh = "${playerctl} play-pause";
              };

              "XF86AudioStop" = mkAllowedWhenLocked {
                spawn-sh = "${playerctl} stop";
              };

              "XF86AudioPrev" = mkAllowedWhenLocked {
                spawn-sh = "${playerctl} previous";
              };

              "XF86AudioNext" = mkAllowedWhenLocked {
                spawn-sh = "${playerctl} next";
              };
              "XF86MonBrightnessUp" = mkAllowedWhenLocked {
                spawn-sh = "${brightnessctl} --class=backlight -q s 10%+";
              };

              "XF86MonBrightnessDown" = mkAllowedWhenLocked {
                spawn-sh = "${brightnessctl} --class=backlight -q s 10%-";
              };
            }
            # Navigation
            {
              "Mod+Down".focus-window-or-workspace-down = _: {};
              "Mod+Up".focus-window-or-workspace-up = _: {};
              "Mod+Left".focus-column-left = _: {};
              "Mod+Right".focus-column-right = _: {};

              "Mod+J".focus-window-or-workspace-down = _: {};
              "Mod+K".focus-window-or-workspace-up = _: {};
              "Mod+H".focus-column-left = _: {};
              "Mod+L".focus-column-right = _: {};

              "Mod+Ctrl+Down".move-window-down-or-to-workspace-down = _: {};
              "Mod+Ctrl+Up".move-window-up-or-to-workspace-up = _: {};
              "Mod+Ctrl+Left".move-column-left = _: {};
              "Mod+Ctrl+Right".move-column-right = _: {};

              "Mod+Ctrl+J".move-window-down-or-to-workspace-down = _: {};
              "Mod+Ctrl+K".move-window-up-or-to-workspace-up = _: {};
              "Mod+Ctrl+H".move-column-left = _: {};
              "Mod+Ctrl+L".move-column-right = _: {};

              "Mod+1".focus-workspace = 1;
              "Mod+2".focus-workspace = 2;
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;

              "Mod+O" = mkNoRepeat {
                toggle-overview = _: {};
              };

              "Mod+F".maximize-column = _: {};
              "Mod+Shift+F".fullscreen-window = _: {};
              "Mod+V".toggle-window-floating = _: {};

              "Mod+Shift+E".quit = _: {};
            }
          ];

        window-rules = [
          {
            matches = [{app-id = "tui-menu";}];
            open-focused = true;
            open-floating = true;

            default-column-width = {
              fixed = 900;
            };

            default-window-height = {
              fixed = 600;
            };
          }
        ];

        # layer-rules = [
        #   {
        #     matches = [{namespace = "^notifications$";}];
        #     block-out-from = "screen-capture";
        #     opacity = 0.8;
        #   }
        # ];
      };
    };
  };
}
