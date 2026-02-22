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
      # imports = with self.homeModules; [
      #   niri-waybar
      #   niri-mako
      #   niri-fuzzel
      #   niri-swaylock
      #   # ./_niri-configs
      # ];

      # options = ./_options.nix;

      services.swayidle.enable = true; # idle management daemon
      services.polkit-gnome.enable = true; # polkit

      home.packages = with pkgs; [
        brightnessctl
        playerctl
        wireplumber
        swaybg # wallpaper
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

          spawn-at-startup "waybar_launcher" "start"
        ''
        #! spawn kitty terminal at start up for exit strategy
        ''
          spawn-at-startup "bash" "-c" "kitty" "&" "disown" 
        ''
        # Base variablse
        ''
          // Uncomment this line to ask the clients to omit their client-side decorations if possible.
          // If the client will specifically ask for CSD, the request will be honored.
          // Additionally, clients will be informed that they are tiled, removing some client-side rounded corners.
          // This option will also fix border/focus ring drawing behind some semitransparent windows.
          // After enabling or disabling this, you need to restart the apps for this to take effect.
          prefer-no-csd

          screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
        ''
        # add remaining configuration files
        (builtins.readFile ./design.kdl)
        (builtins.readFile ./input.kdl)
        (builtins.readFile ./keybinds.kdl)
        (builtins.readFile ./monitors.kdl)
        (builtins.readFile ./window-rules.kdl)
      ];
    };
}
