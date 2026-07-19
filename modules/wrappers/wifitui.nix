{
  inputs,
  lib,
  ...
}: {
  flake.wrapperModules."wifitui" = inputs.wrappers.lib.wrapModule ({config, ...}: let
    tomlFormat = config.pkgs.formats.toml {};
  in {
    options = {
      settings = lib.mkOption {
        type = tomlFormat.type;
        default = {
          Primary = ["#FFA500" "#FFA500"];
          Subtle = ["#BDBDBD" "#919191"];
          Success = ["#388E3C" "#81C784"];
          Error = ["#D32F2F" "#E57373"];

          # Normal text color.
          Normal = ["#212121" "#EEEEEE"];

          # Disabled color, used for hidden or out-of-range networks.
          Disabled = ["#E0E0E0" "#626262"];

          # Border color for UI elements.
          Border = ["#BDBDBD" "#616161"];

          # Signal color is a gradient from SignalHigh to SignalLow.
          SignalHigh = ["#00B300" "#00FF00"];
          SignalLow = ["#D05F00" "#BC3C00"];

          # Color for saved networks.
          Saved = ["#00459E" "#54A5F6"];

          # Icons.
          TitleIcon = "🛜 ";
          NetworkSecureIcon = "🔒 ";
          NetworkOpenIcon = "🔓 ";
          NetworkUnknownIcon = "❓ ";
          NetworkSavedIcon = "💾 ";
          AccessPointIcon = "📡";
        };
        description = ''
          All colors in the provided example above need to be defined, as
          the program will fail the instant one of the above color references
          are not met.
        '';
      };
    };
    config = {
      package = config.pkgs.wifitui;
      flags = {
        "--theme" = tomlFormat.generate "settings.toml" config.settings;
      };
    };
  });
}
