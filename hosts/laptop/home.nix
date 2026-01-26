{
  pkgs,
  username,
  ...
}:
{

  modules = {
    vscode = {
      enable = true;
      packs = {
        nix.enable = true;
      };
    };
    terminal.name = "kitty";
    cli = {
      yazi.enable = true;
      newsboat.enable = true;
      fastfetch.enable = true;
    };
    fonts = {
      enable = true;
      primary = "JetBrainsMono Nerd Font";
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka-term-slab
        inter
      ];
    };
  };

  home = {
    packages = with pkgs; [
      tealdeer
      vim
      git
      gnumake
      vscode
      nixfmt
    ];

    inherit username;
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "25.11"; # Do not update this. Needs to be the same version as denoted in flake.nix
}
