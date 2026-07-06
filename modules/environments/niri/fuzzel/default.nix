{
  inputs,
  self,
  self',
  theme,
  ...
}: let
  moduleName = "niri-fuzzel";
in {
  flake.nixosModules."${moduleName}" = {pkgs, ...}: {
    programs.fuzzel = {
      enable = true;
      package = self'.packages."${moduleName}";
    };
  };

  flake.homeModules."${moduleName}" = {pkgs, ...}: {
    programs.fuzzel = {
      enable = true;
      package = self'.packages."${moduleName}";
    };
  };

  perSystem = {pkgs, ...}: {
    packages."${moduleName}" = inputs.wrapperModules.wrappers.fuzzel.wrap {
      inherit pkgs;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=12";
          dpi-aware = "yes";
          prompt = "\"❯ \"";
          icons-enabled = "yes";
          terminal = "kitty";
          width = 40;
          lines = 12;
          horizontal-pad = 8;
          vertical-pad = 8;
          inner-pad = 8;
          image-size-ratio = 0.5;
          layer = "overlay";
        };

        colors = with self.theme; {
          background = "${base00}ff"; # base
          text = "${base05}ff"; # text
          prompt = "${base06}ff";
          placeholder = "${base04}ff";
          input = "${base05}ff"; # text
          match = "${base0E}ff";
          selection = "${base03}ff";
          selection-text = "${base05}ff"; # text
          selection-match = "${base0E}ff";
          counter = "${base04}ff";
          border = "${base0E}ff";
        };

        border = {
          width = 1;
          radius = 0;
        };

        key-bindings = {
          # cancel = "Escape Control+g";
          # execute = "Return KP_Enter";
          # "execute-or-next" = "Tab";
          # cursor-left = "Left Control+b";
          # cursor-right = "Right Control+f";
          # "delete-line-forward" = "Control+k";
        };
      };
    };
  };
}
