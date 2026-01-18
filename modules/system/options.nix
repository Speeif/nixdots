{ lib }:
{
  modules = with lib; {

    displayManager = {
      ly = {
        enable = mkEnableOption ''
          Enable ly configuration
        '';

        theme = mkOption {
          type = types.enum [
            "doom"
            "matrix"
            "colormix"
            "gameoflife"
            "none"
          ];
          default = "none";
          description = "Background theme of the ly displayManager";
        };
      };

      lemurs = {
        enable = mkEnableOption ''
          Enables the lemurs display manager.
        '';
      };
    };

    boot = {
      logging = mkEnableOption "Should enable logging for the boot service";
      theme = mkOption {
        # Only picked themes from adi1080's pack that I liked.
        # Find relevant names here https://github.com/NixOS/nixpkgs/pull/215693/files
        type = types.enum [
          "rings"
          "seal_2"
          "unrap"
          "square_hud"
        ];
        example = "rings";
        default = "rings";
        description = ''
          Theme for boot loader's loading screen.
        '';
      };
    };

    wifi = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enables wireless networking
        '';
      };
      type = mkOption {
        type = types.enum [
          "base"
          "iwd"
        ];
        default = "base";
        description = ''
          Chooses the type of networking to use.
        '';
      };
    };

    environments = mkOption {
      type = types.nonEmptyListOf (
        types.enum [
          "gnome"
          "cosmic"
        ]
      );
      default = [ "gnome" ];
      example = [
        "gnome"
        "cosmic"
      ];
      description = ''
        The list of environments to enable.

        An environment in this system is considered a collection of specified applications,
        strewn together, to make a functional environment for work / development / other.

        You can find and see the definitions in <root>/system-modules/environments
      '';
    };
  };
}
