{
	inputs = {
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	};
	outputs = { self, nixpkgs, neovim-nightly-overlay }@inputs: {
		nixosConfigurations = {
# (if (builtins.readFile /etc/machine-id) == "e0c725c9906148dcb7cd848c7e9fcd28\n"
# 	then ./Desktop.nix
# 	else ./Laptop.nix)
			BrianNixLaptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [ 
					./Laptop.nix 
					./common.nix
					./hardware-configuration.nix
					./zsh.nix
				];
			};
			BrianNixDesktop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [ 
					./Desktop.nix 
					./common.nix
					./hardware-Desktop.nix
					./zsh.nix
				];
			};
		};
	};
}
