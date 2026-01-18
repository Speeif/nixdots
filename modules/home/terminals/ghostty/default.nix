{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.terminal;
  palette = config.palette;
  font = config.modules.fonts.primary;
in
{
  config = lib.mkIf (cfg.name == "ghostty") {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty;
      settings = {
        # Window settings
        window-padding-x = 14;
        window-padding-y = 14;
        background-opacity = 0.95;
        window-decoration = "none";

        font-family = "${font}";
        font-size = 12;

        theme = "static";

        keybind = [
          "ctrl+k=reset"
        ];
      };

      # Define static theme
      themes = {
        static = with palette; {
          background = "#${base00}";
          foreground = "#${base05}";

          selection-background = "#${base02}";
          selection-foreground = "#${base00}";
          palette = [
            "0=#${base00}"
            "1=#${base08}"
            "2=#${base0B}"
            "3=#${base0A}"
            "4=#${base0D}"
            "5=#${base0E}"
            "6=#${base0C}"
            "7=#${base05}"
            "8=#${base03}"
            "9=#${base08}"
            "10=#${base0B}"
            "11=#${base0A}"
            "12=#${base0D}"
            "13=#${base0E}"
            "14=#${base0C}"
            "15=#${base07}"
            "16=#${base09}"
            "17=#${base0F}"
            "18=#${base01}"
            "19=#${base02}"
            "20=#${base04}"
            "21=#${base06}"
          ];
        };
      };
    };
  };
}
