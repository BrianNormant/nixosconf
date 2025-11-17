{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
		ce-program.url = "github:myclevorname/nix-calculators";
		nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
		portfolio.url = "github:BrianNormant/portfolio";
		winapps.url = "github:winapps-org/winapps";
		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = {nixpkgs, nixpkgs-stable, nixvim, nixpkgs-xr, winapps, ... }@inputs: {
		nixosConfigurations =
		let
			system = "x86_64-linux";
			specialArgs = {
				inherit inputs;
				pkgs-stable = import nixpkgs-stable {inherit system;};
			};
			overlays = inputs: {
				nixpkgs = {
					overlays = [
						(final: prev: {
							inherit (winapps.packages.${system}) winapps;
							inherit (winapps.packages.${system}) winapps-launcher;
						})
					];
				};
			};
		in {
			BrianNixLaptop = nixpkgs.lib.nixosSystem {
				inherit system; inherit specialArgs;
				modules = [
					./Laptop.nix
					./common.nix
					./hardware-Laptop.nix
					./nixvim.nix
					nixvim.nixosModules.default
					overlays
				];
			};
			BrianNixDesktop = nixpkgs.lib.nixosSystem {
				inherit system; inherit specialArgs;
				modules = [
					./Desktop.nix
					./common.nix
					./hardware-Desktop.nix
					./nixvim.nix
					nixvim.nixosModules.default
					nixpkgs-xr.nixosModules.nixpkgs-xr
					overlays
				];
			};
			BrianNixServer = nixpkgs-stable.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					./Server.nix
					./Server-Services.nix
					./hardware-Server.nix
					./nixvim.nix
					inputs.portfolio.nixosModules.portfolio-api
					nixvim.nixosModules.default
				];
			};
		};
		templates.default = {
			path = ./template;
			description = ''
				A template for a nixos configuration.
				with flake-parts
				and a default TMUX script for dev-env
			'';
		};
	};
}
