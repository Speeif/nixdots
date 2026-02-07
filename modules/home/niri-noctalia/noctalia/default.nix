{
  config,
  pkgs,
  inputs,
  flakeDir,
  ...
}:
{

  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    quickshell
  ];

  programs.noctalia-shell = {
    enable = false;
  };

  xdg.configFile."noctalia/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home/niri-noctalia/noctalia/settings.json";
}
