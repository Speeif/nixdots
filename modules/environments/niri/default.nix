{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules."niri" =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        zathura
      ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
    };

  flake.homeModules."niri" =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = with self.homeModules; [
        niri-waybar
        niri-mako
        niri-fuzzel
        niri-swaylock
      ];

      options = import ./_options.nix { inherit lib; };

      config = {

        services.swayidle.enable = true; # idle management daemon
        services.polkit-gnome.enable = true; # polkit

        home.packages = with pkgs; [
          brightnessctl
          playerctl
          wireplumber
          swaybg # wallpaper
          wlr-which-key
          wlogout
        ];

        xdg.configFile."niri/config.kdl".text =
          let
            mkMenu =
              { name, config }:
              let
                theme = self.themeHashed;
                configFile = pkgs.writeText "config.yaml" (
                  lib.generators.toYAML { } {
                    font = "${self.defaultFont} 12";
                    anchor = "center";
                    background = theme.base02;
                    color = theme.base05;
                    border = theme.base0D;
                    border_width = 2;
                    corner_r = 0;
                    padding = 5;

                    margin_left = 0;
                    margin_right = 0;
                    margin_top = 0;
                    margin_bottom = 0;

                    inhibit_compositor_keyboard_shortcuts = true;

                    menu = config;
                  }
                );
              in
              # make spaced name dash seperated
              pkgs.writeShellScriptBin "${builtins.replaceStrings [ " " ] [ "-" ] name}" ''
                exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
              '';

            mkBindMenu =
              bind:
              { name, config }@menuConfig:
              ''
                ${bind} { spawn-sh "${lib.getExe (mkMenu menuConfig)}"; }
              '';
            mkStartupCmd =
              command:
              builtins.concatStringsSep " " (
                map (word: "\"${word}\"") (builtins.filter builtins.isString (builtins.split " " command))
              );
          in
          builtins.concatStringsSep "\n" [
            # description
            ''
              // This config is in the KDL format: https://kdl.dev
              // "/-" comments out the following node.
              // Check the wiki for a full description of the configuration:
              // https://yalter.github.io/niri/Configuration:-Introduction

            ''
            # Spawn processes
            ''
              // Add lines like this to spawn processes at startup.
              // Note that running niri as a session supports xdg-desktop-autostart,
              // which may be more convenient to use.
              // See the binds section below for more spawn examples.

              spawn-at-startup ${mkStartupCmd config.niri-commands.bar.start}
            ''
            ''
              binds {
            ''
            (mkBindMenu "Mod+B" {
              name = "Waybar options";
              config = with config.niri-commands.bar; [
                {
                  key = "1";
                  desc = "Start";
                  cmd = "${start}";
                }
                {
                  key = "2";
                  desc = "Stop";
                  cmd = "${stop}";
                }
                {
                  key = "3";
                  desc = "Restart";
                  cmd = "${restart}";
                }
                {
                  key = "4";
                  desc = "Debug";
                  cmd = "${debug}";
                }
              ];
            })
            (builtins.readFile ./keybinds.kdl)
            ''
              }
            ''
            #! spawn kitty terminal at start up for exit strategy
            ''
              spawn-at-startup "bash" "-c" "kitty" "&" "disown" 
            ''
            # Base variablse
            ''
              prefer-no-csd // no client side decorations
              screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
            ''
            # add remaining configuration files
            (builtins.readFile ./design.kdl)
            (builtins.readFile ./input.kdl)
            (builtins.readFile ./monitors.kdl)
            (builtins.readFile ./window-rules.kdl)
          ];
      };
    };

  flake.nixosModules."myNiri" =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.testNiri;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages."testNiri" = inputs.wrapperModules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          input = {
            keyboard = {
              xkb.layout = "dk";
              numlock = _: { };
            };

            touchpad = {
              tap = _: { };
              natural-scroll = _: { };
            };

            warp-mouse-to-focus = _: { };
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
            (lib.getExe self'.packages.testWaybar)
          ];

          layout = {
            gaps = 6;
            # one of [ "never" "always" "on-overflow" ]
            center-focused-column = "never";
            # default values kept <3
            preset-column-widths = [
              { proportion = 0.33; }
              { proportion = 0.5; }
              { proportion = 0.66; }
            ];

            default-column-width = {
              proportion = 0.5;
            };

            focus-ring = {
              width = 8;
              active-color = self.themeHashed.base0D;
              inactive-color = self.themeHashed.base03;
            };

            border = {
              off = _: { };
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
          #   content = { spawn-sh = "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          #     };
          #   };
          binds =
            let
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
                    spawn-sh = lib.getExe pkgs.fuzzel;
                  };
                };
                "Mod+B".spawn-sh =
                  let
                    pgrep = lib.getExe' pkgs.procps "pgrep";
                    pkill = lib.getExe' pkgs.procps "pkill";
                    waybar = lib.getExe self'.packages.testWaybar;
                    #
                    maybeStart = "${pgrep} -f ${waybar} || ${lib.getExe pkgs.bash} ${waybar} &";
                    maybeStop = "${pgrep} -f ${waybar} && ${pkill} -f ${waybar}";

                    launcher = pkgs.writeShellScriptBin "abekatten-hugo444" ''
                      set -euo pipefail

                      WAYBAR=${waybar}
                      PKILL=${pkill}
                      PGREP=${pgrep}

                      START2="${maybeStart}"
                      STOP2="${maybeStop}"
                    '';
                  in
                  self.mkWhichKeyExe pkgs [
                    {
                      key = "1";
                      desc = "Start";
                      cmd = maybeStart;
                    }
                    {
                      key = "2";
                      desc = "Stop";
                      cmd = maybeStop;
                    }
                    {
                      key = "3";
                      desc = "Restart";
                      cmd = "${maybeStop}; ${maybeStart}";
                    }
                    {
                      key = "4";
                      desc = "Debug";
                      cmd = "${launcher} stop && GTK_DEBUG=interactive && ${maybeStart}";
                    }
                  ];
                "Mod+Q" = mkNoRepeat {
                  close-window = _: { };
                };
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
                  spawn-sh = "${brightnessctl} --class=backlight set +10%";
                };

                "XF86MonBrightnessDown" = mkAllowedWhenLocked {
                  spawn-sh = "${brightnessctl} --class=backlight set -10%";
                };
              }
              # Navigation
              {
                "Mod+Down".focus-window-or-workspace-down = _: { };
                "Mod+Up".focus-window-or-workspace-up = _: { };
                "Mod+Left".focus-column-left = _: { };
                "Mod+Right".focus-column-right = _: { };

                "Mod+J".focus-window-or-workspace-down = _: { };
                "Mod+K".focus-window-or-workspace-up = _: { };
                "Mod+H".focus-column-left = _: { };
                "Mod+L".focus-column-right = _: { };

                "Mod+Ctrl+Down".move-window-down-or-to-workspace-down = _: { };
                "Mod+Ctrl+Up".move-window-up-or-to-workspace-up = _: { };
                "Mod+Ctrl+Left".move-column-left = _: { };
                "Mod+Ctrl+Right".move-column-right = _: { };

                "Mod+Ctrl+J".move-window-down-or-to-workspace-down = _: { };
                "Mod+Ctrl+K".move-window-up-or-to-workspace-up = _: { };
                "Mod+Ctrl+H".move-column-left = _: { };
                "Mod+Ctrl+L".move-column-right = _: { };

                "Mod+1".focus-workspace = 1;
                "Mod+2".focus-workspace = 2;
                "Mod+3".focus-workspace = 3;
                "Mod+4".focus-workspace = 4;

                "Mod+O" = mkNoRepeat {
                  toggle-overview = _: { };
                };

                "Mod+F".maximize-column = _: { };
                "Mod+Shift+F".fullscreen-window = _: { };
                "Mod+V".toggle-window-floating = _: { };

                "Ctrl+Shift+Delete".quit = _: { };

                "Shift+Mod+Print".spawn-sh =
                  "${lib.getExe pkgs.grim} -l 0 - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
              }
            ];
        };
      };
    };
}
