{
  inputs,
  self,
  ...
}: let
  moduleName = "wifitui";
  theme = self.themeHashed;
in {
  perSystem = {pkgs, ...}: {
    packages."${moduleName}" = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package =
        (self.wrapperModules.${moduleName}.apply {
          inherit pkgs;
          settings = {
            Primary = [theme.base0C theme.base07];
            Subtle = [theme.base0E theme.base04];
            Success = [theme.base0B theme.base0B];
            Error = [theme.base08 theme.base09];

            # Normal text color.
            Normal = [theme.base00 theme.base05];

            # Disabled color, used for hidden or out-of-range networks.
            Disabled = ["#E0E0E0" "#626262"];

            # Border color for UI elements.
            Border = [theme.base0D theme.base0C];

            # Signal color is a gradient from SignalHigh to SignalLow.
            SignalHigh = ["#00B300" "#00FF00"];
            SignalLow = ["#D05F00" "#BC3C00"];

            # Color for saved networks.
            Saved = [theme.base09 theme.base0A];

            # Icons.
            # TitleIcon = "🛜 ";
            # NetworkSecureIcon = "🔒 ";
            # NetworkOpenIcon = "🔓 ";
            # NetworkUnknownIcon = "❓ ";
            # NetworkSavedIcon = "💾 ";
            # AccessPointIcon = "📡";
          };
        }).wrapper;
    };
  };
}
