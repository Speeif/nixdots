{ inputs, self, ... }:
let
  moduleName = "mpv";
in
{
  flake.homeModules."${moduleName}" =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;
        package = self.packages."${pkgs.system}"."${moduleName}";
      };
    };

  perSystem =
    {
      config,
      lib,
      wlib,
      pkgs,
      ...
    }:
    {
      packages."${moduleName}" = inputs.wrapperModules.wrappers.mpv.wrap {
        inherit pkgs;
        package = pkgs.mpv;
        scripts = with pkgs.mpvScripts; [
          sponsorblock
          uosc
          mpris
        ];
        "mpv.conf".content = ''
          profile=high-quality
          keep-open=always

          fullscreen=no

          sub-bold=yes
          sub-auto=fuzzy
        '';
      };
    };
}
