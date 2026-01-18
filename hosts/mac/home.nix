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
        node.enable = true;
        flutter.enable = true;
      };
    };
    terminal.name = "kitty";
    cli = {
      yazi.enable = true;
      newsboat.enable = true;
      fastfetch.enable = true;
    };
    fonts.enable = true;
  };

  home = {
    packages = with pkgs; [
      tealdeer
      git
      gnumake
      vscode
      nixfmt # nix formatter
    ];

    inherit username;
    homeDirectory = "/home/${username}";
  };
}
