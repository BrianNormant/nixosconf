{pkgs, lib, ...}:
{
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
