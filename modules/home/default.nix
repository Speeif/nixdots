{ lib, pkgs, ... }:
{
  options = (import ./options.nix { inherit lib pkgs; });

  imports = [
    ./vscode
    ./shells
    ./cli
    ./terminals
    ./fonts
    ./niri-noctalia
    ./programs
  ];
}
