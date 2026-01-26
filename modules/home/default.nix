{ lib, pkgs, ... }:
{
  options = (import ./options.nix { inherit lib pkgs; });

  imports = [
    ./vscode
    ./shells
    ./cli
    ./terminals
    ./fonts
    ./suppliments # Everything else
  ];
}
