{ config, pkgs, ... }:

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

}
