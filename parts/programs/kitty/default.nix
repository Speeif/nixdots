{ self, ... }:
{
  flake.nixosModules."kitty" =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        kitty
      ];
    };

  flake.homeModules."kitty" =
    { pkgs, ... }:
    {
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;
        font = {
          name = "${self.defaultFont}";
          size = 12;
        };
        settings =
          let
            theme = self.themeHashed;
          in
          {
            confirm_os_window_close = 0; # diable check
            # dynamic_background_opacity = true;
            enable_audio_bell = false;
            mouse_hide_wait = "-1.0";
            window_padding_width = 5;

            ## Due to the blur not working (I don't wanna debug)
            ## I have disabled it fully.
            # background_opacity = "0.2";
            # background_blur = 5;

            background = theme.base00;
            foreground = theme.base07;

            cursor = theme.base07;

            color0 = theme.base00;
            color1 = theme.base08;
            color2 = theme.base0B;
            color3 = theme.base0A;
            color4 = theme.base0D;
            color5 = theme.base0E;
            color6 = theme.base0C;
            color7 = theme.base03;
            color8 = theme.base02;
            color9 = theme.base08;
            color10 = theme.base0B;
            color11 = theme.base0A;
            color12 = theme.base0D;
            color13 = theme.base0E;
            color14 = theme.base0C;
            color15 = theme.base03;
          };
      };
    };
}
