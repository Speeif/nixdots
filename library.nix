{
  mkPkgs =
    {
      nixpkgs,
      system,
      allowUnfree ? [ ],
    }:
    import nixpkgs {
      inherit system;
      # Allow only select unfree packages
      config.allowUnfreePredicate = pkgs: builtins.elem (nixpkgs.lib.getName pkgs) allowUnfree;
    };
}
