{
  description = "My nixos flake with homoe manager";

  inputs = {
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

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      myLib = import ./library.nix;
      username = "speeif";
      hostname = "hermes";
      flakeDir = "${builtins.getEnv "HOME"}/nix/flake";
    in
    {
      nixosConfigurations = {
        "laptop" =
          let
            system = "x86_64-linux";
            pkgs = myLib.mkPkgs { inherit system nixpkgs; };
          in
          nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            modules = [
              { system.stateVersion = "25.11"; } # follow nixpkgs
              ./hosts/laptop/system.nix
              ./modules/system
            ];
            specialArgs = {
              inherit
                system
                username
                hostname
                inputs
                ;
            };
          };
      };

      homeConfigurations = {
        "leasure" =
          let
            system = "x86_64-linux";
            pkgs = myLib.mkPkgs {
              inherit system nixpkgs;
              allowUnfree = [
                "obsidian"
                "vscode"
              ];
            };
            privateModules = inputs.private-modules.homeManagerModules.${system};
          in
          home-manager.lib.homeManagerConfiguration {
            modules = [
              { home.stateVersion = "25.11"; } # follow home-manager
              ./hosts/laptop/home.nix
              ./modules/home
              privateModules.default
            ];
            inherit pkgs;
            extraSpecialArgs = {
              inherit
                system
                username
                hostname
                flakeDir
                inputs
                ;
            };
          };

        "mac" =
          let
            system = "x86_64-linux";
            pkgs = myLib.mkPkgs {
              inherit system nixpkgs;
              allowUnfree = [
                "obsidian"
                "vscode"
              ];
            };
          in
          home-manager.lib.homeManagerConfiguration {
            modules = [
              { home.stateVersion = "25.11"; } # follow home-manager
              ./hosts/mac/home.nix
              ./modules/home
            ];
            inherit pkgs;
            extraSpecialArgs = {
              inherit
                system
                username
                hostname
                flakeDir
                inputs
                ;
            };
          };
      };
    };
}
