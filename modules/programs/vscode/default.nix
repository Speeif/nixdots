{
  flakeDir,
  inputs,
  self,
  self',
  ...
}: let
  moduleName = "vscode";
in {
  #! NOTE: this is not how you do nixos modules
  # Due to how I use vscode, trying out new extensions, in-app updatings, and generally
  # my development flow depending on quick nudges as I am not 'set' in how I use this
  #
  # software yet, I want to limit the amount of changes I would need for this file.
  # I have tried wrapping the module, I have tried using the command line tool to
  # configure, and I have exhausted my 'wanting' to configure this piece fully.
  #
  # As this is also how 'vscode' was designed to be, I conscribe it to a fault
  # in system philosophy, and may later try other code editing tools.
  flake.homeModules."${moduleName}" = {
    pkgs,
    config,
    ...
  }: let
    mkConfLink = target: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${target}";
  in {
    home.packages = with pkgs; [
      alejandra
      nixd
    ];
    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    xdg.configFile."VSCodium/User/keybindings.json".source = mkConfLink "/nix/flake/modules/programs/vscode/keybindings.json";
    xdg.configFile."VSCodium/User/settings.json".source = mkConfLink "/nix/flake/modules/programs/vscode/settings.json";
    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium-fhs;
      # keybindings.source = ./keybinding.json;
    };
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
