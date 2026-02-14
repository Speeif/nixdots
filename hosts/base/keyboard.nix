{ ... }:
{
  flake.nixosModules."keyboard" =
    { ... }:
    {
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "dk";
        variant = "nodeadkeys";
      };

      # Configure console keymap
      console.keyMap = "dk-latin1";
    };
}
