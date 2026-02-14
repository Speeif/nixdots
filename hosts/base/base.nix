{
  self,
  ...
}:
{
  flake.nixosModules."systemBase" =
    { pkgs, username, ... }:
    {
      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      imports = with self.nixosModules; [
        sound
        keyboard
        localization
        networking
        boot
        fonts
      ];

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${username} = {
        isNormalUser = true;
        description = "${username}";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [
          home-manager
        ];
        shell = pkgs.zsh;
      };

      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;

      environment.systemPackages = with pkgs; [
        vim
        nano
      ];

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # ! LEAVE THIS! READ COMMENT!!!
    };

  flake.homeModules."homeBase" =
    { userhome, username, ... }:
    {
      imports = with self.homeModules; [
        fonts
      ];

      home = {
        inherit username;
        homeDirectory = "${userhome}";
      };

      home.stateVersion = "25.11";
    };
}
