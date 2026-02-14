{ ... }:
{
  flake.nixosModules.boot =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options = with lib; {
        bootTheme = mkOption {
          type = types.enum [
            "rings"
            "seal_2"
            "unrap"
            "square_hud"
          ];
          default = "rings";
        };
      };

      config = {
        boot.initrd.verbose = false;
        boot.consoleLogLevel = 3;
        boot.kernelParams = [
          "splash"
          "boot.shell_on_fail"
          "rd.systemd.show_status=auto"
          "quiet"
          "udev.log_priority=3"
        ];

        boot.plymouth = {
          enable = true;
          theme = "${config.bootTheme}";
          themePackages = with pkgs; [
            # By default we would install all themes
            (adi1090x-plymouth-themes.override {
              selected_themes = [ "${config.bootTheme}" ];
            })
          ];
        };
        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        boot.loader = {
          timeout = 0;
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };

    };
}
