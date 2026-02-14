{ ... }:
{
  flake.nixosModules."fonts" =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka-term-slab
        inter
      ];
    };

  flake.homeModules."fonts" =
    { ... }:
    {
      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          serif = [ "IosevkvaTermSlab Nerd Font" ];
          sansSerif = [ "Inter" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };

  flake = {
    defaultFont = "JetBrainsMono Nerd Font";
  };
}
