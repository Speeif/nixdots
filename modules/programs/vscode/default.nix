{
  flakeDir,
  inputs,
  self,
  self',
  ...
}:
let
  moduleName = "vscode";
in
{
  flake.homeModules."${moduleName}" =
    { pkgs, config, ... }:
    {
      programs.vscodium = {
        enable = true;
        package = self.packages."${pkgs.system}"."${moduleName}";

        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          userSettings.source = ./settings.json;
        };
        # keybindings.source = ./keybinding.json;
      };
    };

  perSystem =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      packages."${moduleName}" = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package =
          with pkgs;
          vscode-with-extensions.override {
            vscode = vscodium;
            #! Remember: `attribute 'vscodeExtUniqueId' missing` means that an extension was not found.
            vscodeExtensions =
              with vscode-extensions;
              [
                # Nix
                bbenoist.nix
                jnoortheen.nix-ide
              ]
              ++ [
                # Themes   # Editor versatility and formatters
                catppuccin.catppuccin-vsc
                catppuccin.catppuccin-vsc-icons
              ]
              ++ [
                # Editing extensions
                esbenp.prettier-vscode
                editorconfig.editorconfig
                aaron-bond.better-comments
              ];
          };
      };
    };
}
