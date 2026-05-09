{
  flakeDir,
  inputs,
  self,
  ...
}:
let
  moduleName = "niri-waybar";
in
{
  flake.homeModules."${moduleName}" =
    { pkgs, config, ... }:
    {
      programs.waybar = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}."${moduleName}";
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages."${moduleName}" = inputs.wrapperModules.wrappers.waybar.wrap {
        inherit pkgs;
        settings =
          let
            launchTui = tui: "bash -c \"${lib.getExe pkgs.kitty} -e ${tui}\"";
          in
          {
            reload_style_on_change = true;
            layer = "top";
            position = "top";
            mod = "dock";
            margin-top = 3;
            height = 24;
            margin-left = 5;
            margin-right = 5;
            margin-bottom = 0;
            "group/left1" = {
              orientation = "inherit";
              modules = [
                "custom/system"
                "custom/seperator"
                "clock"
                "custom/seperator"
                "idle_inhibitor"
              ];
            };
            "group/left2" = {
              orientation = "inherit";
              modules = [
                "niri/workspaces"
              ];
            };
            "group/left3" = {
              orientation = "inherit";
              modules = [
                "mpris"
              ];
            };
            modules-left = [
              "group/left1"
              "group/left2"
              "group/left3"
            ];
            modules-center = [
              "niri/window"
            ];
            modules-right = [
              "group/right1"
              "group/right2"
            ];
            "group/right1" = {
              orientation = "inherit";
              modules = [
                "tray"
              ];
            };
            "group/right2" = {
              orientation = "inherit";
              modules = [
                "bluetooth"
                "backlight"
                "network"
                "custom/seperator"
                "pulseaudio#output"
                "custom/microphone"
                "custom/seperator"
                "memory"
                "cpu"
                "battery"
              ];
            };
            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = "一";
                "2" = "二";
                "3" = "三";
                "4" = "四";
                "5" = "五";
                "6" = "六";
              };
              persistent-workspaces = {
                "*" = [
                  1
                  2
                  3
                  4
                  5
                  6
                ];
              };
            };
            "custom/system" = {
              format = "";
              on-click = "${lib.getExe pkgs.wlogout}";
            };
            "niri/workspaces" = {
              format = "{icon}";
              format-icons = {
                browser = "";
                discord = "";
                chat = "<b></b>";
                active = "";
                default = "";
              };
            };
            "niri/window" = {
              format = "{}";
              rewrite = {
                "(.*) - Mozilla Firefox" = "🌎 $1";
                "(.*) - zsh" = "> [$1]";
              };
            };
            cpu = {
              interval = 1;
              format = "CPU {icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              on-click = launchTui "${lib.getExe pkgs.btop}";
            };
            memory = {
              interval = 1;
              format = "MEM {icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              max-length = 10;
              on-click = launchTui "${lib.getExe pkgs.btop}";
            };
            battery = {
              format = "BAT {icon}";
              format-discharging = "BAT {icon}";
              format-charging = "BAT^ {icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              format-full = "";
              tooltip-format-discharging = "{timeTo}";
              tooltip-format-charging = "{timeTo}";
              interval = 5;
              states = {
                warning = 20;
                critical = 10;
              };
            };
            clock = {
              format = "{:%H:%M %a} ";
              format-alt = " {:%d/%m/%Y  %H:%M:%S}";
              tooltip-format = "<span>{calendar}</span>";
              calendar = {
                mode = "month";
                weeks-pos = "right";
                mode-mon-col = 3;
                on-click-right = "mode";
                format = {
                  month = "<span color='${self.themeHashed.base06}'><b>{}</b></span>";
                  weekdays = "<span color='${self.themeHashed.base0A}'><b>{}</b></span>";
                  today = "<span color='${self.themeHashed.base08}'><b>{}</b></span>";
                };
              };
            };
            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "󰛊";
                deactivated = "󰾫";
              };
            };
            network = {
              format = "NET {icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              format-wifi = "NET {icon}";
              format-ethernet = "ETH";
              format-disconnected = "X";
              tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
              tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
              tooltip-format-disconnected = "Disconnected";
              interval = 3;
              nospacing = 1;
              on-click = launchTui "${lib.getExe' pkgs.networkmanager "nmtui"}";
            };
            bluetooth = {
              format = "";
              format-disabled = "󰂲";
              format-off = "󰂲";
              format-connected = "";
              tooltip-format = "Devices connected: {num_connections}";
              on-click = launchTui "${lib.getExe pkgs.bluetui}";
            };
            backlight = {
              device = "intel_backlight";
              format = "SCR {icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              tooltip-format = "Screen light: {percent}%";
            };
            "pulseaudio#output" = {
              format = "SND {icon}";
              tooltip-format = "Volume: {volume}%";
              format-muted = "SND X";
              format-bluetooth = "HDST {icon}";
              format-icons = [
                "󰝦"
                "󰪞"
                "󰪟"
                "󰪠"
                "󰪡"
                "󰪢"
                "󰪣"
                "󰪤"
                "󰪥"
              ];
              max-volume = 100;
              scroll-step = 2;
              smooth-scrolling-threshold = 1;
              on-click = launchTui "${lib.getExe pkgs.wiremix}";
              on-click-right = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            "custom/microphone" = {
              exec = "bash /home/speeif/nix/flake/modules/environments/niri/waybar/microphone.sh @DEFAULT_SOURCE@ MIC 9";
              execute-on-event = false;
              format = "{text} {icon}";
              interval = 5;
              return-type = "json";
              format-icons = {
                "0" = "󰝦";
                "1" = "󰪞";
                "2" = "󰪟";
                "3" = "󰪠";
                "4" = "󰪡";
                "5" = "󰪢";
                "6" = "󰪣";
                "7" = "󰪤";
                "8" = "󰪥";
                muted = "X";
                on-scroll-down = "wpctl set-volume @DEFAULT_SOURCE@ 5%- >/dev/null && echo '{\"text\":\"NO\"}'";
                on-scroll-up = "wpctl set-volume @DEFAULT_SOURCE@ 5%+ >/dev/null && echo '{\"text\":\"NO\"}'";
                on-click = "kitty --class=pavucontrol -e pavucontrol";
              };
            };
            tray = {
              icon-size = 12;
              spacing = 10;
              icons = {
                "blueman" = "bluetooth";
              };
            };
            mpris = {
              format = "󰋎 {artist} - {title}";
              format-paused = "<i>{status_icon} {artist}</i>";
              max-length = 20;
              player-icons = {
                default = "⏸";
                mpv = "🎵";
              };
              status-icons = {
                paused = "󰋐";
              };
              ignored-players = [
                "firefox"
                "chromium"
                "brave"
              ];
            };
            "custom/seperator" = {
              format = " ";
            };

          };

        "style.css".path = "${flakeDir}/modules/environments/niri/waybar/style.css";
      };
    };
}
