{ ... }:
{
  flake.homeModules."obsidian" =
    { pkgs, ... }:
    {
      programs.obsidian.enable = true;
    };
}
