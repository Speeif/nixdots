{ ... }:
{
  flake.homeModules."niri-fuzzel" =
    { pkgs, ... }:
    {
      programs.fuzzel = {
        enable = true;
      };
    };
}
