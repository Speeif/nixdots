{
  config,
  lib,
  pkgs,
  self,
  flakeDir,
  ...
}:
let
  cfg = config.modules.vscode;
  packs = config.modules.vscode.packs;
in
{
  config = lib.mkIf cfg.enable {
    home.packages =
      [ ]
      ++ lib.optionals (packs.nix.enable) [
        pkgs.nixd # language server
        pkgs.nixfmt-rfc-style # formatter
        pkgs.shfmt # shell formatter ()
      ];

    # settings
    # As this file is being endlessly edited, possibly per project, and
    # shoudn't be made static, I've opted for a symlink solution, and keeping
    # my settings in VCS.
    # This is discouraged by nix standards, so I should discourage it, but
    # that'd make me a hypocrite.
    xdg.configFile."Code/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home/vscode/settings.json";

    # Key binds
    # As this file is being endlessly edited, possibly per project, and
    # shoudn't be made static, I've opted for a symlink solution, and keeping
    # my settings in VCS.
    # This is discouraged by nix standards, so I should discourage it, but
    # that'd make me a hypocrite.
    xdg.configFile."Code/User/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${flakeDir}/modules/home/vscode/keybindings.json";

    programs.vscode = {
      enable = true;
      profiles.default = {
        # userSettings defined in ./settings.json
        # (in progress, so not part of nix)
        # userSettings = { };
        extensions =
          with pkgs.vscode-extensions;
          [
            # Themes
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            # Editor versatility and formatters
            esbenp.prettier-vscode
            editorconfig.editorconfig
            aaron-bond.better-comments
          ]
          ++ lib.optionals (packs.nix.enable) [
            bbenoist.nix # Nix language support
            pkgs.vscode-extensions.bbenoist.nix
            jnoortheen.nix-ide
          ]
          ++ lib.optionals (packs.flutter.enable) [
            dart-code.flutter
            dart-code.dart-code
            alexisvt.flutter-snippets

            lokalise.i18n-ally
            fill-labs.dependi
          ]
          ++ lib.optionals (packs.node.enable) [
            fill-labs.dependi
            Orta.vscode-jest
          ]
          ++ lib.optionals (packs.go.enable) [
            golang.go
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            # define direct fetching of extensions from github here.
            # example at http://nixos.wiki/wiki/VSCodium
          ];
      };
    };
  };
}
