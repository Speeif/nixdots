{ pkgs, ... }:
{
  imports = [
    ./yazi
    ./newsboat
    ./fastfetch
  ];

  home.packages = with pkgs; [
    btop
    lazydocker
    lazygit
    tealdeer
    bat
  ];
}
