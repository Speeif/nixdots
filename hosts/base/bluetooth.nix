{...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    # Nixified bluetooth options. See https://github.com/bluez/bluez/blob/master/src/main.conf
    settings = {
      General = {
        Experimental = false;
      };
      Policy = {
        AutoEnable = false;
      };
    };
  };
}
