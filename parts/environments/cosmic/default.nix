{ ... }:
{
  flake.nixosModules."cosmic" =
    { ... }:
    {
      services.desktopManager.cosmic = {
        enable = true;
      };
    };
}
