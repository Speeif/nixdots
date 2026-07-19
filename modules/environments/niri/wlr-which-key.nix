{
  inputs,
  self,
  ...
}: let
  theme = self.themeHashed;
in {
  #? Taken from github:vimjoyer/nixconf
  #? https://github.com/vimjoyer/nixconf/blob/af218435ce14b8a974d0409dcd116e575f117262/wrappedPrograms/wlr-which-key/default.nix
  flake.wrapperModules."wrapped-which-key" = inputs.wrappers.lib.wrapModule (
    {
      config,
      lib,
      ...
    }: let
      yamlFormat = config.pkgs.formats.yaml {};
    in {
      options = {
        settings = lib.mkOption {
          type = yamlFormat.type;
        };
        menu = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
        };
      };

      config = {
        package = config.pkgs.wlr-which-key;

        args = let
          fullSettings =
            config.settings
            // {
              menu = config.menu;
            };
        in [
          (toString (yamlFormat.generate "config.yaml" fullSettings))
        ];
      };
    }
  );

  flake.mkWhichKey = pkgs: menu:
    (self.wrapperModules."wrapped-which-key".apply {
      inherit pkgs menu;
      settings = {
        font = "JetBrainsMono Nerd Font 12";
        anchor = "center";
        background = theme.base01;
        color = theme.base05;
        border = theme.base0D;
        border_width = 2;
        corner_r = 0;
        padding = 5;

        margin_left = 0;
        margin_right = 0;
        margin_top = 0;
        margin_bottom = 0;

        inhibit_compositor_keyboard_shortcuts = true;
      };
    }).wrapper;
}
