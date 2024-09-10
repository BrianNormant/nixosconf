{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
	};
	ouputs = { self, nixpkgs }: {
		nixosConfigurations.BrianNixLaptop = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [ ./configuration.nix ];
		};
	};
};
