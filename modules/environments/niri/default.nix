{ self, ... }:
{
  flake.nixosModules."niri" =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        niri
      ];
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
        ];

        xdg.configFile."niri/config.kdl".text =
          let
            mkMenu =
              { name, config }:
              let
                configFile = pkgs.writeText "config.yaml" (
                  lib.generators.toYAML { } {
                    anchor = "bottom-right";
                    menu = config;
                  }
                );
              in
              # make spaced name dash seperated
              pkgs.writeShellScriptBin "${builtins.replaceStrings [ " " ] [ "-" ] name}" ''
                exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
              '';

            mkBindMenu = bind: menuConfig: ''
              ${bind} { spawn-sh "${lib.getExe (mkMenu menuConfig)}"; }
            '';
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

              spawn-at-startup "waybar_launcher" "start"
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
}
