ollamaAPIEndpoint:
{ config, ...}: {
	age.secrets.open-webui = {
		file = ../secrets/open-webui.age;
		owner = "open-webui";
		group = "open-webui";
	};
	services.open-webui = {
		enable = true;
		host = "127.0.0.1"; # hide this behind nginx
		port = 43941;
		openFirewall = true;
		environment = {
			ANONYMIZED_TELEMETRY = "True";
			DO_NOT_TRACK = "True";
			SCARF_NO_ANALYTICS = "True";
			OLLAMA_BASE_URL="${ollamaAPIEndpoint}";
		};
		environmentFile = config.age.secrets.open-webui.path;
	};
}
