{
	inputs = {
		neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
		ce-program.url = "github:myclevorname/nix-calculators";
	};
	outputs = { self, nixpkgs, nixpkgs-stable, neovim-nightly-overlay, ... }@inputs: {
		nixosConfigurations =
		let
			system = "x86_64-linux";
			specialArgs = {
				inherit inputs;
				pkgs-stable = import nixpkgs-stable {system = "x86_64-linux";};
			};
		in {
			BrianNixLaptop = nixpkgs.lib.nixosSystem {
				inherit system; inherit specialArgs;
				modules = [
					./Laptop.nix
					./common.nix
					./hardware-Laptop.nix
					./zsh.nix
				];
			};
			BrianNixDesktop = nixpkgs.lib.nixosSystem {
				inherit system; inherit specialArgs;
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
