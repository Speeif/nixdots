{ ... }:
{
  flake.nixosModules."niri" =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        niri
      ];
    };

  flake.homeModules."niri" =
    { pkgs, ... }:
    let
      barCommand = ''"waybar"'';
    in
    {
      home.packages = with pkgs; [
        brightnessctl
        swaylock
        fuzzel
        playerctl
        mpvScripts.mpris
        wireplumber
        waybar
      ];

      xdg.configFile."niri/config.kdl".text = builtins.concatStringsSep "\n" [
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

          spawn-at-startup ${barCommand}
        ''
        #! spawn kitty terminal at start up for exit strategy
        ''
          spawn-at-startup "bash" "-c" "kitty" "&" "disown" 
        ''
        # Base variablse
        ''
          hotkey-overlay {
              // Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
              // skip-at-startup
          }

          // Uncomment this line to ask the clients to omit their client-side decorations if possible.
          // If the client will specifically ask for CSD, the request will be honored.
          // Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
          // This option will also fix border/focus ring drawing behind some semitransparent windows.
          // After enabling or disabling this, you need to restart the apps for this to take effect.
          prefer-no-csd

          // You can change the path where screenshots are saved.
          // A ~ at the front will be expanded to the home directory.
          // The path is formatted with strftime(3) to give you the screenshot date and time.
          screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
        ''
        # add remaining configuration files
        (builtins.readFile ./design.kdl)
        (builtins.readFile ./input.kdl)
        (builtins.readFile ./keybinds.kdl)
        (builtins.readFile ./monitors.kdl)
        (builtins.readFile ./noctalia-window-rules.kdl)
        (builtins.readFile ./window-rules.kdl)
      ];
    };
}
