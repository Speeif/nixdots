{ ... }:
{
  flake.nixosModules."networking" =
    { hostname, ... }:
    {
      networking = {
        hostName = hostname;
        networkmanager = {
          enable = true;
        };
      };
    };
}
