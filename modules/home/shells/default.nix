{
  pkgs,
  ...
}:
let

in
{
  # All shells enabled by default, as the handling of shells
  # is per-user / per-session, and is handled by the system,
  # not home-manager.
  imports = [
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    zsh
    fzf
    bat
    eza
    btop
  ];
}
