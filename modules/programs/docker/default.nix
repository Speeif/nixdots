{ ... }:
{
  flake.nixosModules."docker" =
    { username, ... }:
    {
      virtualisation.docker.enable = true;
      users.users.${username}.extraGroups = [ "docker" ];
    };

  flake.homeModules."docker" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lazydocker
      ];
    };
}
