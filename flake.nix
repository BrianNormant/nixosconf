{
	inputs = {
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        ce-program.url = "github:myclevorname/nix-calculators";
	};
	outputs = { self, nixpkgs, neovim-nightly-overlay, ... }@inputs: {
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
			BrianNixServer = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					./Server.nix
					./hardware-Server.nix
					./zsh.nix
				];
			};
		};
	};
}
