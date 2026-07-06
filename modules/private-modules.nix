{inputs, ...}: {
  flake.homeModules."private" = inputs.private-modules.homeModules.default;

  flake.nixosModules."private" = inputs.private-modules.nixosModules.default;
}
