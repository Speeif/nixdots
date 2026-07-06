{
  flakeDir,
  inputs,
  self,
  ...
}: let
  moduleName = "niri-waybar";
in {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages."${moduleName}" = inputs.wrapperModules.wrappers.waybar.wrap {
      inherit pkgs;
      settings = let
        launchTui = tui: "bash -c \"${lib.getExe pkgs.kitty} -e ${tui}\"";
        progressIcons = [
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
      in {
        reload_style_on_change = true;
        layer = "top";
        position = "top";
        mod = "dock";
        height = 24;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        margin-top = 0;

        modules-left = [
          "group/left1"
          "group/left2"
          "group/left3"
        ];
        modules-center = [
          "niri/window"
        ];
        modules-right = [
          "bluetooth"
          "backlight"
          "custom/seperator"
          "pulseaudio#output"
          "custom/microphone"
          "custom/seperator"
          "network"
          "memory"
          "cpu"
          "battery"
        ];

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
          format-icons = progressIcons;
          on-click = launchTui "${lib.getExe pkgs.btop}";
        };
        memory = {
          interval = 1;
          format = "MEM {icon}";
          format-icons = progressIcons;
          max-length = 10;
          on-click = launchTui "${lib.getExe pkgs.btop}";
        };
        battery = {
          format = "BAT {icon}";
          format-discharging = "BAT {icon}";
          format-charging = "BAT^ {icon}";
          format-icons = progressIcons;
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
          format = "{:%H:%M %a}";
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
          format-icons = progressIcons;
          format-wifi = "NET {icon}";
          format-ethernet = "ETH";
          format-disconnected = "NET X";
          tooltip-format-wifi = "{essid} ({frequency} GHz)\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 3;
          nospacing = 1;
          on-click = launchTui "${lib.getExe' pkgs.networkmanager "nmtui"}";
        };
        bluetooth = {
          format = "BT {icon}";
          format-icons = progressIcons;
          format-disabled = "BT /";
          format-off = "BT X";
          format-connected = "BT 󰪥";
          tooltip-format = "Devices connected: {num_connections}";
          on-click = launchTui "${lib.getExe pkgs.bluetui}";
          on-click-right = let
            bluetoothctl = "${lib.getExe' pkgs.bluez "bluetoothctl"}";
          in "${bluetoothctl} power $(${bluetoothctl} show | ${lib.getExe pkgs.gnugrep} -q \"Powered: yes\" && echo off || echo on)";
        };
        backlight = {
          device = "intel_backlight";
          format = "SCR {icon}";
          format-icons = progressIcons;
          tooltip-format = "Screen light: {percent}%";
        };
        "pulseaudio#output" = {
          format = "SND {icon}";
          tooltip-format = "Volume: {volume}%";
          format-muted = "SND X";
          format-bluetooth = "HDST {icon}";
          format-icons = progressIcons;
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
          };
          on-click-right = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_SOURCE@ toggle";
          on-scroll-down = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_SOURCE@ 5%-";
          on-scroll-up = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_SOURCE@ 5%+";
          on-click = "${lib.getExe pkgs.pavucontrol}";
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
          max-length = 35;
          player-icons = {
            default = "⏸";
            mpv = "🎵";
          };
          status-icons = {
            paused = "󰋐";
          };
          ignored-players = [
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
