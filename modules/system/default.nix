{ lib, ... }:
{
  # import options
  options = (import ./options.nix { inherit lib; });

  imports = [
    ./networking
    ./environments
    ./boot
    ./display-managers
  ];
}
