{...}: {
  flake.homeModules."niri-mako" = {pkgs, ...}: {
    services.mako = {
      enable = true;
    };
  };
}
