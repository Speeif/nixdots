{ inputs, ... }:
let
  mkPkgs =
    {
      system,
      allowUnfree ? [ ],
    }:
    import inputs.nixpkgs {
      inherit system;
      # Allow only select unfree packages
      config.allowUnfreePredicate = pkgs: builtins.elem (inputs.nixpkgs.lib.getName pkgs) allowUnfree;
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
      };
    };
in
{
  inherit mkHome mkPkgs mkNixos;
}
