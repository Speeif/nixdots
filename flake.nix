{
  description = "My nixos flake with homoe manager";

  inputs = {
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Remove or use own private repo if not me!
    private-modules = {
      url = "git+ssh://git@github.com/speeif/nixdots-private.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs@{
      flake-parts,
      home-manager,
      import-tree,
      ...
    }:
    let
      myLib = import ./library.nix { inherit inputs; };
      #? flakeDir is used for linking config files (e.g. vscode settings.json)
      #? since the home-manager.lib.mkOutOfStoreSymlink needs a root path
      flakeDir = "${builtins.getEnv "PWD"}";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux" # todo: update for "x86_64-darwin"
      ];

      _module.args = {
        inherit
          inputs
          flakeDir
          myLib
          ;
      };

      imports = [
        flake-parts.flakeModules.modules
        home-manager.flakeModules.home-manager
      ]
      ++ [ (import-tree ./modules) ] # import all flake-parts
      ++ [
        # hosts
        ./hosts/laptop.nix
      ];
    };
}
