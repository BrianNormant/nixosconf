{ pkgs, pkgs-stable, ...}: {
	networking.hostName = "BrianNixLaptop"; # Define your hostname.

	boot.loader.systemd-boot.consoleMode = "max";
	boot.kernelPackages = pkgs.linuxPackages_latest;

	services.fprintd = {
		enable = true;
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


}
