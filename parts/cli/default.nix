{ self, ... }:
{
  flake.nixosmOdules."default-cli" =
    { ... }:
    {
      imports = with self.nixosModules; [
        shell-zsh
      ];
    };

  flake.homeModules."default-cli" =
    { pkgs, ... }:
    {
      imports = with self.homeModules; [
        shell-zsh
        yazi
        fastfetch
        newsboat
      ];

      home.packages = with pkgs; [
        git
        btop
        lazydocker
        lazygit
        tealdeer
        bat
        gnumake
      ];
    };
}
