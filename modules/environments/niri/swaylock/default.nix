{ ... }:
{
  flake.homeModules."niri-swaylock" =
    { pkgs, ... }:
    {
      programs.swaylock = {
        enable = true;
      };
    };
}
