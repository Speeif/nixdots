{
  flakeDir,
  myLib,
  self,
  ...
}:
let
  allowUnfree = [
    "vscode"
    "vscode-extension-fill-labs-dependi"
    "obsidian"
  ];
in
{

  imports = [
    ./base/default.nix
    ./gpu/amd.nix
  ];

  flake =
    let
      username = "speeif";
      hostname = "hermes";
      userhome = "/home/${username}";
    in
    {
      nixosConfigurations."nixos" = myLib.mkNixos "x86_64-linux" {
        inherit allowUnfree;
        specialArgs = {
          inherit
            username
            hostname
            flakeDir
            userhome
            ;
        };
        modules =
          with self.nixosModules;
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

      homeConfigurations."nixos" = myLib.mkHome "x86_64-linux" {
        inherit allowUnfree;
        modules =
          with self.homeModules;
          [
            # setup
            homeBase
            niri
          ]
          ++ [
            private
            default-cli
            vscode
            kitty
            mpv
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
}
