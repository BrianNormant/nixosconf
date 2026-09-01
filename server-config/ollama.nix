{pkgs, main-user, ...}:
{
	users.users."${main-user}".extraGroups = [ "ollama" ];
	services.ollama = {
		enable = true;
		package = pkgs.ollama-vulkan;
		user = "ollama";
		rocmOverrideGfx = "11.0.0";
		loadModels = [
			"gemma3:27b"
		];
		environmentVariables = {
			"OLLAMA_ORIGINS" = "*";
		};
		openFirewall = true;
		host = "127.0.0.1";
	};
}
