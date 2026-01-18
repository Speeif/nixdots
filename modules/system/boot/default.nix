{
  pkgs,
  lib,
  config,
  ...
}:
let
  shouldLog = config.modules.boot.logging;
  theme = config.modules.boot.theme;
in
{

  config = {
    boot.initrd.verbose = lib.mkIf (!shouldLog) false;
    boot.consoleLogLevel = lib.mkIf (!shouldLog) 3;
    boot.kernelParams = [
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=auto"
    ]
    ++ lib.optionals (!shouldLog) [
      "quiet"
      "udev.log_priority=3"
    ];

    boot.plymouth = {
      enable = lib.mkIf (!shouldLog) true;
      theme = "${theme}";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "${theme}" ];
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

}
