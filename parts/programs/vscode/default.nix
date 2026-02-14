{ flakeDir, ... }:
{
  flake.homeModules."vscode" =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      mkLink = file: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/parts/programs/vscode/${file}";
    in
    {

      xdg.configFile."Code/User/settings.json".source = mkLink "settings.json";

      xdg.configFile."Code/User/keybindings.json".source = mkLink "keybindings.json";

      home.packages = [
        pkgs.nixd # language server
        pkgs.nixfmt-rfc-style # formatter
        pkgs.shfmt # shell formatter ()
      ];

      programs.vscode = {
        enable = true;
        profiles.default = {
          extensions =
            with pkgs.vscode-extensions;
            [
              # nix
              bbenoist.nix # Nix language support
              pkgs.vscode-extensions.bbenoist.nix
              jnoortheen.nix-ide
              # Themes
              catppuccin.catppuccin-vsc
              catppuccin.catppuccin-vsc-icons
              # Editor versatility and formatters
              esbenp.prettier-vscode
              editorconfig.editorconfig
              aaron-bond.better-comments
            ]
            ++ [
              # flutter
              dart-code.flutter
              dart-code.dart-code
              alexisvt.flutter-snippets
              fill-labs.dependi
              # js
              # todo: not working
              # orta.vscode-jest
            ];
        };
      };
    };
}
