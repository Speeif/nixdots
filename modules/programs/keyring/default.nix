{self, ...}: {
  flake.nixosModules."gnome-keyring" = {pkgs, ...}: {
    services.gnome.gnome-keyring.enable = true;
    environment.systemPackages = with pkgs; [
      seahorse
    ];
  };
}
