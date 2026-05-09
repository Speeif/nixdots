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

    wrapperModules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:Lassulus/wrappers/3819a607b845cc1ef492a6682970b17ac83ebdaf?narHash=sha256-AkOIcYzvVtoLQzrvdEeSEH/dvgVxvbJcKpKGHu8l67w%3D";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dendritic imports
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
          myLib
          ;
        flakeDir = "/home/speeif/nix/flake";
      };

      perSystem =
        { system, ... }:
        {
          _module.args = {
            pkgs = import inputs.nixpkgs {
              inherit system;
            };
            pkgs-unstable = import inputs.nixpkgs-unstable {
              inherit system;
            };
          };
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
