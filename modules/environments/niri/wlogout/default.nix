{
  flakeDir,
  inputs,
  self,
  ...
}: let
  moduleName = "wlogout";
in {
  flake.wrapperModules."${moduleName}" = inputs.wrappers.lib.wrapModule (
    {
      config,
      lib,
      wlib,
      pkgs,
      ...
    }: let
      yamlFormat = config.pkgs.formats.yaml {};
    in {
      options = {
        "layout.json" = lib.mkOption {
          type = wlib.types.file config.pkgs;
          default.content = builtins.readFile ./layout.json;
        };
        "theme.css" = lib.mkOption {
          type = wlib.types.file config.pkgs;
          default.content = builtins.readFile ./theme.css;
        };
        "style.css" = lib.mkOption {
          type = wlib.types.file config.pkgs;
          default.content = builtins.readFile ./style.css;
        };
      };

      config = let
        cssFile = pkgs.writeTextFile {
          name = "wlogout-style.css";
          text = ''
            ${config."theme.css".content}
            ${config."styel.css".content}
          '';
        };
      in {
        package = config.pkgs.wlogout;
        flags = {
          "--layout" = config.layout.path;
          "--css" = cssFile;
        };
        args = let
          fullSettings =
            config.settings
            // {
              menu = config.menu;
            };
        in [
          (toString (yamlFormat.generate "config.yaml" fullSettings))
        ];
      };
    }
  );

  perSystem = {pkgs, ...}: {
    packages."${moduleName}" =
      (self.wrapperModules."${moduleName}".apply {
        inherit pkgs;
      }).wrapper;
  };
}
