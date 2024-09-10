{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};
	outputs = { self, nixpkgs }: {
		nixosConfigurations = {
		# (if (builtins.readFile /etc/machine-id) == "e0c725c9906148dcb7cd848c7e9fcd28\n"
		# 	then ./Desktop.nix
		# 	else ./Laptop.nix)
		./zsh.nix
	];
			BrianNixLaptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ 
					./Laptop.nix 
					./common.nix
					./hardware-configuration.nix
					./zsh.nix
					];
			};
			BrianNixDesktop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ 
					./Desktop.nix 
					./common.nix
					./hardware-configuration.nix
					./zsh.nix
					];
			};
	};
}
