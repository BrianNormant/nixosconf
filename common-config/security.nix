{pkgs, lib, main-user, ...}:
{
	users = {
		users = {
			"${main-user}" = {
				extraGroups = [ "wheel" ];
			};
		};
	};
	security = {
		polkit = {
			enable = true;
		};
		sudo = {
			enable = true;
		};
	};
}
