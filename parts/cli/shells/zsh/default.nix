{ self, ... }:
{
  flake.nixosModules."shell-zsh" =
    { pkgs, ... }:
    {
      environment.systemPackages = with self.nixosModules; [
        zsh
      ];

    };

  flake.homeModules."shell-zsh" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        fzf
        bat
        eza
        btop
      ];

      imports = with self.homeModules; [
        zsh
        oh-my-posh
      ];
    };
}
