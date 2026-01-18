{ lib, pkgs }:
with lib;
{
  modules = {
    vscode = {
      enable = mkEnableOption ''
        Enables vscode config
      '';

      packs = {
        nix.enable = mkEnableOption ''
          Enables extensions for the nix ecosystem
        '';
        flutter.enable = mkEnableOption ''
          Enables extensions for the flutter ecosystem
        '';
        node.enable = mkEnableOption ''
          Enables extensions for the node ecosystem
        '';
        go.enable = mkEnableOption ''
          Enables extensions for the go ecosystem
        '';
      };
    };

    terminal = {
      name = mkOption {
        type = types.enum [
          "kitty"
          "ghostty"
        ];
        default = "kitty";
      };
    };

    cli = {
      yazi = {
        enable = mkEnableOption ''
          installs and configures the yazi terminal file manager
        '';
      };
      newsboat = {
        enable = mkEnableOption ''
          enables newsboat module.
        '';
      };

      fastfetch = {
        enable = mkEnableOption ''
          enables fastfetch and overrides the neofetch command in both zsh and bash.
        '';
      };
    };

    fonts = {
      enable = mkEnableOption ''
        Makes home-manager use font config
      '';

      packages = mkOption {
        type = types.listOf types.package;
        default = [
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.inter
          pkgs.nerd-fonts.iosevka-term-slab
        ];
        description = ''
          The list of fonts to include (use pkgs.nerd-fonts for nerd fonts).
        '';
      };

      primary = mkOption {
        type = types.str;
        default = "JetBrainsMono Nerd Font";
      };

      defaultFonts = {
        serif = mkOption {
          type = types.listOf types.str;
          default = [
            "IosevkvaTermSlab Nerd Font"
          ];
        };
        sansSerif = mkOption {
          type = types.listOf types.str;
          default = [ "Inter" ];
        };
        monospace = mkOption {
          type = types.listOf types.str;
          default = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };
  };

  palette = lib.mkOption {
    type = lib.types.attrs;
    default = {
      base00 = "24273a"; # base
      base01 = "1e2030"; # mantle
      base02 = "363a4f"; # surface0
      base03 = "494d64"; # surface1
      base04 = "5b6078"; # surface2
      base05 = "cad3f5"; # text
      base06 = "f4dbd6"; # rosewater
      base07 = "b7bdf8"; # lavender
      base08 = "ed8796"; # red
      base09 = "f5a97f"; # peach
      base0A = "eed49f"; # yellow
      base0B = "a6da95"; # green
      base0C = "8bd5ca"; # teal
      base0D = "8aadf4"; # blue
      base0E = "c6a0f6"; # mauve
      base0F = "f0c6c6"; # flamingo
    };
    description = ''
      The palette to use with different programs. Uses catppuccin-machiato as default
    '';
  };
}
