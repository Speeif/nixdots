{ inputs, ... }:
{
  flake.homeModules."private" =
    { system, ... }:
    {
      imports = [
        inputs.private-modules.homeManagerModules.${system}.viu
      ];
    };
}
