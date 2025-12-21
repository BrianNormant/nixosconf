{pkgs, lib, main-user, ...}:
{
	users.users."${main-user}".extraGroups = ["corectrl"];
	programs = {
		corectrl = {
			enable = true;
		};
	};
	services = {
		power-profiles-daemon = {
			enable = true;
		};
		upower = {
			enable = true;
		};
	};
}
