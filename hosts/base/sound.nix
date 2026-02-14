{ ... }:
{
  flake.nixosModules."sound" =
    { lib, config, ... }:
    let
      cfg = config.soundSystem;
    in
    {
      options = with lib; {
        soundSystem = {
          version = mkOption {
            type = types.enum [
              "pipewire"
              "pulseaudio"
            ];
            default = "pipewire";
            description = ''
              Sets the type of sound system to use
            '';
          };
        };
      };

      config = lib.mkMerge [
        {
          # enable real-time scheduling for unpriviledged user processes.
          security.rtkit.enable = true;
        }
        (lib.mkIf (cfg.version == "pipewire") {
          services.pulseaudio.enable = false;
          services.pipewire = {
            enable = true;
            # Install ALSA imitation API to route ALSA request through pipewire
            alsa = {
              enable = true;
              support32Bit = true; # include 32bit sound requests
            };
            # enable PA imitation API to route PA server traffic.
            pulse.enable = true;

            # install wireplumber to handle device management
            # Will not switch audio source without
            # Enabled for modern DE like GNOME.
            wireplumber.enable = true;
          };
        })
        (lib.mkIf (cfg.version == "pulseaudio") {
          # TODO: have not tested
          services.pulseaudio.enable = true;
        })
      ];
    };
}
