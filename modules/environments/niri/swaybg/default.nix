{...}: {
  flake.homeModules."niri-swaybg" = {pkgs, ...}: {
    programs.swaybg.enable = true;
  };
}
