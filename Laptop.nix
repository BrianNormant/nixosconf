{ config, pkgs, ... }:

{
	networking.hostName = "BrianNixLaptop"; # Define your hostname.
	
	boot.loader.systemd-boot.consoleMode = "max";
	boot.kernelPackages = pkgs.linuxPackages_latest;

	services.fprintd = {
		enable = true;
		tod.enable = true;
		tod.driver = pkgs.libfprint-2-tod1-vfs0090;
	};
	
	# Either manage to use ssh as a secondary network
	# Or open a port and configure network port redirecting
	services.open-webui = {
		enable = false;
		port = 3000;
		environment = {
			OLLAMA_API_BASE_URL = "http://ggkbrian:11434";
			WEBUI_AUTH = "False";
		};
	};

	# services.tlp = {
	# 	enable = true;
	# 	settings = {
	# 		CPU_SCALING_GOVERNOR_ON_AC = "performance";
	# 		CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
	#
	# 		CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
	# 		CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
	#
	# 		CPU_MIN_PERF_ON_AC   =  0;
	# 		CPU_MAX_PERF_ON_AC   =  100;
	# 		CPU_MIN_PERF_ON_BAT  =  0;
	# 		CPU_MAX_PERF_ON_BAT  =  20;
	# 	};
	# };

}
