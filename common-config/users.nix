{pkgs, lib, main-user, ...}:
{
	users = {
		users = {
			"${main-user}" = {
				isNormalUser = true;
				extraGroups = [
					"adbusers"
				];
				shell = pkgs.zsh;
				# home-manager manage the packages
			};
		};
	};

	# Stuff root and every user should have access to
	environment = {
		systemPackages = with pkgs; [
			wget
			curl
			file
			acpi
			zip unzip
			unrar
			p7zip
			fastfetch # Extrement important!!!
			bluez # bluetooth headphones
			bc
			sshfs
		];
	};
	programs = {
		tmux = {
			enable = true;
			keyMode = "vi";
		};
		niri = { enable = true; };
	};
}
