{inputs, ...}: let
  moduleName = "wlogout";
in {
  flake.wrapperModules."${moduleName}" = inputs.wrappers.lib.wrapModule (
    {
      config,
      lib,
      wlib,
      ...
    }: {
      options = {
        "layout" = lib.mkOption {
          type = wlib.types.file config.pkgs;
          default.content = builtins.readFile ./layout;
        };
        "style.css" = lib.mkOption {
          type = wlib.types.file config.pkgs;
          default.content = builtins.readFile ./style.css;
        };
        margin = lib.mkOption {
          type = lib.types.int;
          default = 230;
          description = ''
            The margin accross all axis, e.g. top, right, bottom and left.
          '';
        };
        margin-top = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
        };
        margin-right = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
        };
        margin-bottom = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
        };
        margin-left = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
        };
        row-spacing = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        column-spacing = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };
        buttons-per-row = lib.mkOption {
          type = lib.types.int;
          default = 3;
        };
        no-span = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Stops spanning accross monitors";
        };
        show-binds = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Shows the keybinds on their corresponding buttons";
        };
        primary-monitor = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
        };
      };

      config = let
        marginNullCheck = value:
          if value == null
          then config.margin
          else value;
      in {
        package = config.pkgs.wlogout;
        flags = {
          "--layout" = config."layout".path;
          "--css" = config."style.css".path;
          "--row-spacing" = toString config.row-spacing;
          "--column-spacing" = toString config.column-spacing;
          "--buttons-per-row" = toString config.buttons-per-row;
          "--margin" = toString config.margin;
          "--margin-top" = toString (marginNullCheck config.margin-top);
          "--margin-right" = toString (marginNullCheck config.margin-right);
          "--margin-bottom" = toString (marginNullCheck config.margin-bottom);
          "--margin-left" = toString (marginNullCheck config.margin-left);
          "--no-span" = toString config.no-span;
        };
      };
    }
  );
}
