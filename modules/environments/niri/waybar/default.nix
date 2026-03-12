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
        #shell
        set -euo pipefail

        CONFIG_FILE="${home}/.config/waybar/config.jsonc"
        STYLE_FILE="${home}/.config/waybar/style.css"

        WAYBAR_BIN="${pkgs.waybar}/bin/waybar"
        PKILL_BIN=${pkgs.procps}/bin/pkill
        PGREP_BIN=${pkgs.procps}/bin/pgrep

        start() {
          if $PGREP_BIN -f $WAYBAR_BIN >/dev/null; then
            echo "Waybar is already running."
            return 0
          fi

          echo "Starting Waybar..."
          $WAYBAR_BIN \
            --config "$CONFIG_FILE" \
            --style "$STYLE_FILE" &
        }

        stop() {
          if ! $PGREP_BIN -f $WAYBAR_BIN >/dev/null; then
            echo "Waybar is not running."
            return 0
          fi

          echo "Stopping Waybar..."
          $PKILL_BIN -f $WAYBAR_BIN
        }

        restart() {
          echo "Restarting Waybar..."
          stop || true
          sleep 0.2
          start
        }

        case "$1" in
          start)
            start
            ;;
          stop)
            stop
            ;;
          restart)
            restart
            ;;
          *)
            start 
            ;;
        esac
      '';

    in
    {
      home.packages = with pkgs; [
        waybarLauncher
        bluetui
      ];
      programs.waybar = {
        enable = true;
      };
      xdg.configFile."waybar/config.jsonc".source = mkLink "config.jsonc";
      xdg.configFile."waybar/style.css".source = mkLink "style.css";
      xdg.configFile."waybar/theme.css".source = mkLink "theme.css";

      niri-commands.bar = {
        start = "${scriptName} start";
        stop = "${scriptName} stop";
        restart = "${scriptName} restart";
        debug = "GTK_DEBUG=interactive ${scriptName} restart";
      };
    };
}
