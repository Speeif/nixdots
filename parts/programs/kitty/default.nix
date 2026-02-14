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

            foreground = "#f8f8f2";
            background = "#1e1e2e";

            color0 = "#45475a";
            color1 = "#f38ba8";
            color2 = "#a6e3a1";
            color3 = "#f9e2af";
            color4 = "#89b4fa";
            color5 = "#f5c2e7";
            color6 = "#94e2d5";
            color7 = "#bac2de";
          };
      };
    };
}
