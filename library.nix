{ inputs, ... }:
let
  mkPkgs =
    {
      system,
      allowUnfree ? [ ],
      nixpkgs ? inputs.nixpkgs,
    }:
    import nixpkgs {
      inherit system;
      # Allow only select unfree packages
      config.allowUnfreePredicate = pkgs: builtins.elem (nixpkgs.lib.getName pkgs) allowUnfree;
    };

  mkHome =
    system:
    {
      allowUnfree ? [ ],
      modules ? [ ],
      extraSpecialArgs ? { },
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit modules;
      pkgs = mkPkgs { inherit system allowUnfree; };
      extraSpecialArgs = extraSpecialArgs // {
        inherit system inputs;
        pkgs-unstable = mkPkgs {
          inherit system allowUnfree;
          nixpkgs = inputs.nixpkgs-unstable;
        };
      };
    };

  mkNixos =
    system:
    {
      allowUnfree ? [ ],
      modules ? [ ],
      specialArgs ? { },
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit modules system;
      pkgs = mkPkgs { inherit system allowUnfree; };
      specialArgs = specialArgs // {
        inherit system inputs;
        pkgs-unstable = mkPkgs {
          inherit system allowUnfree;
          nixpkgs = inputs.nixpkgs-unstable;
        };
      };
    };
in
{
  inherit mkHome mkPkgs mkNixos;
}
