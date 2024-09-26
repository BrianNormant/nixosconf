{
	inputs = {
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		stablepkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
	};
	outputs = { self, nixpkgs, stablepkgs, neovim-nightly-overlay, ... }@inputs: {
		nixosConfigurations = {
			BrianNixLaptop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					./Laptop.nix
					./common.nix
					./hardware-Laptop.nix
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
