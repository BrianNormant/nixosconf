{pkgs, main-user, ...}:
{
	users.users."${main-user}".extraGroups = [ "ollama" ];
	services.ollama = {
		enable = true;
		user = "ollama";
		acceleration = "rocm";
		rocmOverrideGfx = "11.0.0";
		loadModels = [
			"gemma3:27b"
		];
		environmentVariables = {
			"OLLAMA_ORIGINS" = "*";
		};
		openFirewall = true;
		host = "0.0.0.0";
	};
}
