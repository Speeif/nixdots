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
            /etc/nixos/hardware-configuration.nix
            systemBase
          ]
          ++ [
            # actual packages
            ly
            niri
            kitty
            gnome
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
            homeBase
          ]
          ++ [
            private
            niri
            default-cli
            vscode
            kitty
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
