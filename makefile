# Phony targets does not conflict with files, and targets the defined command.

# --impure call to make home-manager read env variable for $HOME
# -b for bakup file extensions
# --flake cause flake
.PHONY: home
home:
	home-manager switch --impure -b bak --flake .#nixos

.PHONY: mac
mac:
	home-manager switch --impure -b bak --flake .#mac

# Only use with nixos as OS.
# As hardware configuration should stay unchanged once installed (imo),
# I reference the auto generated hardware-configuration.

# --impure for reference to /etc/nixos/hardware-configuration.nix
# --flake cause flake
.PHONY: system
system:
	nixos-rebuild switch --impure --flake .#nixos

# Cleans nix home-manager cache. Run with `sudo` to clean system-level cache.
.PHONY: clean
clean:
	nix-collect-garbage -d

# updates the reference to private modules, in calse main has changed
.PHONY: update
update:
	nix flake update private-modules