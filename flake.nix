{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
		portfolio.url = "github:BrianNormant/portfolio";
		winapps.url = "github:winapps-org/winapps";
		nixvim = {
			url = "github:nix-community/nixvim";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = inputs@{nixpkgs, ... }: {
		nixosConfigurations =
		let
			system = "x86_64-linux";
			overlays = i: {
				nixpkgs = {
					overlays = [
						(final: prev: {
							inherit (inputs.winapps.packages.${system}) winapps;
							inherit (inputs.winapps.packages.${system}) winapps-launcher;
						})
						(import ./custom-pkgs/flog-symbols.nix)
						(import ./custom-pkgs/cedarville-cursive.nix)
					];
				};
			};
			mkNixos = {user, hostname, modules}: nixpkgs.lib.nixosSystem {
				inherit system modules;
				specialArgs = { main-user = user; inherit hostname; };
			};
		in import ./configuration.nix {
			inherit mkNixos;
			inherit inputs;
			inherit overlays;
		};
	};
}
