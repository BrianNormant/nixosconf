{ pkgs, ... }:
{
	networking.hostName = "BrianNixLaptop"; # Define your hostname.
	
	boot.loader.systemd-boot.consoleMode = "max";

	services.fprintd = {
		enable = true;
		tod.enable = true;
		tod.driver = pkgs.libfprint-2-tod1-vfs0090;
	};

	services.tlp = {
		enable = true;
		settings = {
			CPU_SCALING_GOVERNOR_ON_AC = "performance";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

			CPU_MIN_PERF_ON_AC   =  0;
			CPU_MAX_PERF_ON_AC   =  100;
			CPU_MIN_PERF_ON_BAT  =  0;
			CPU_MAX_PERF_ON_BAT  =  20;
		};
	};

	home-manager.users.brian = {pkgs, ...}: {
		services.unison.enable = true;
		services.unison.pairs."Music" = {
			roots = [ "/home/brian/Music"
				"ssh://BrianNixDesktopI//home/brian/Music" ]; };
		services.unison.pairs."Prog" = {
			roots = [ "/home/brian/Prog"
				"ssh://BrianNixDesktopI//home/brian/Prog" ]; };
		services.unison.pairs."Wallpapers" = {
			roots = [ "/home/brian/Wallpapers"
				"ssh://BrianNixDesktopI//home/brian/Wallpapers" ]; };
	};
}
