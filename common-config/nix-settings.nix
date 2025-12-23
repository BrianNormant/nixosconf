{pkgs, lib, main-user, ...}:
{
	nixpkgs = {
		flake = {
			setNixPath = true;
			setFlakeRegistry = true;
		};
		config = {
			allowUnfree = true;
		};
	};
	nix = {
		settings = {
			trusted-users = [ "root" "brian" ];
			experimental-features = [
				"nix-command"
				"flakes"
				"pipe-operators"
			];
			sandbox = "relaxed";
		};
	};
	programs = {
		# To run executables not compiled for nixos
		# Can be usefull for java swing apps
			# For java swing
			# fontconfig
			# noto-fonts
			# for zutty
			# ucs-fonts
			# xorg.libxcb
		nix-ld = {enable = false;};
		nh = {
			enable = true;
			clean.enable = true;
			flake = "/home/${main-user}/nixos-config";
		};
	};
}
