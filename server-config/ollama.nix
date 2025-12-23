{pkgs, main-user, ...}:
{
	users.users."${main-user}".extraGroups = [ "ollama" ];
	services.ollama = {
		enable = true;
		package = pkgs.ollama-rocm;
		user = "ollama";
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
