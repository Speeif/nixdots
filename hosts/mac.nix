{
  flakeDir,
  myLib,
  self,
  tester,
  ...
}:
{

  imports = [
    ./base/default.nix
  ];

  flake =
    let
      allowUnfree = [
        "vscode"
        "vscode-extension-fill-labs-dependi"
        "obsidian"
      ];
      username = "speeif";
      hostname = "hermes";
      userhome = "/home/${username}";
    in
    {
      homeConfigurations."mac" = myLib.mkHome "x86_64-darwin" {
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
