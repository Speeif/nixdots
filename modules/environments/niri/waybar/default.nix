{ flakeDir, ... }:
{
  flake.homeModules."niri-waybar" =
    { pkgs, config, ... }:
    let
      location = "${flakeDir}/modules/environments/niri/waybar";
      mkLink = file: config.lib.file.mkOutOfStoreSymlink "${location}/${file}";
      home = config.home.homeDirectory;
      scriptName = "waybar-launcher";
      waybarLauncher = pkgs.writeShellScriptBin "${scriptName}" ''
        set -euo pipefail

        WAYBAR_BIN="${pkgs.waybar}/bin/waybar"
        CONFIG_FILE="${home}/.config/waybar/config.jsonc"
        STYLE_FILE="${home}/.config/waybar/style.css"

        start_waybar() {
          if ${pkgs.procps}/bin/pgrep -x waybar >/dev/null; then
            echo "Waybar is already running."
            exit 0
          fi

          echo "Starting Waybar..."
          "$WAYBAR_BIN" \
            --config "$CONFIG_FILE" \
            --style "$STYLE_FILE" &
        }

        stop_waybar() {
          if ! ${pkgs.procps}/bin/pgrep -x waybar >/dev/null; then
            echo "Waybar is not running."
            exit 0
          fi

          echo "Stopping Waybar..."
          ${pkgs.procps}/bin/pkill -x waybar
        }

        restart_waybar() {
          echo "Restarting Waybar..."
          ${pkgs.procps}/bin/pkill -x waybar 2>/dev/null || true
          sleep 0.2
          start_waybar
        }

        case "$1" in
          start)
            start_waybar
            ;;
          stop)
            stop_waybar
            ;;
          restart)
            restart_waybar
            ;;
          *)
            start_waybar 
            ;;
        esac
      '';

    in

    {
      home.packages = [ waybarLauncher ];
      programs.waybar = {
        enable = true;
      };
      xdg.configFile."waybar/config.json".source = mkLink "config.jsonc";
      xdg.configFile."waybar/style.css".source = mkLink "style.css";
      xdg.configFile."waybar/theme.css".source = mkLink "theme.css";

      niri-commands.bar = {
        start = "${scriptName} start";
        stop = "${scriptName} stop";
        restart = "${scriptName} restart";
      };
    };
}
