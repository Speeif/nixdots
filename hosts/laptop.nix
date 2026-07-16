{
  flakeDir,
  myLib,
  self,
  inputs,
  ...
}: let
  allowUnfree = [
    "vscode"
    "vscode-extension-fill-labs-dependi"
    "obsidian"
    "code"
    "replace"
  ];
in {
  flake = let
    username = "speeif";
    hostname = "hermes";
    userhome = "/home/${username}";
  in {
    nixosConfigurations."laptop" = myLib.mkNixos "x86_64-linux" {
      inherit allowUnfree;
      specialArgs = {
        inherit
          username
          hostname
          flakeDir
          userhome
          ;
      };
      modules = with self.nixosModules;
        [
          # setup
          /etc/nixos/hardware-configuration.nix
          gpu-amd
          systemBase
          niri
          gnome
          gnome-keyring
        ]
        ++ [
          # actual packages
          ly
          kitty
          zsh
        ]
        ++ [
          #programs
          docker
        ];
    };

    homeConfigurations."laptop" = myLib.mkHome "x86_64-linux" {
      inherit allowUnfree;
      modules = with self.homeModules;
        [
          # setup
          homeBase
        ]
        ++ [
          private
          default-cli
          vscode
          kitty
          mpv
          obsidian
        ];
      extraSpecialArgs = {
        inherit
          username
          hostname
          flakeDir
          userhome
          ;
      };
    };
  };

  perSystem = {system, ...}: {
    _module.args.pkgs = myLib.mkPkgs {
      inherit (inputs) nixpkgs;
      inherit system allowUnfree;
    };
  };
}
