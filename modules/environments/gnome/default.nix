{ ... }:
{
  flake.nixosModules."gnome" =
    { pkgs, ... }:
    {
      services.xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      services.desktopManager.gnome.enable = true;

      # remove core tools
      services.gnome = {
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
    };
}
