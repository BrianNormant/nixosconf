{ config, pkgs, ... }: {
	age.secrets."ollama-basic-auth" = {
		file = ../secrets/ollama-basic-auth.age;
		owner = "nginx";
		group = "nginx";
	};
	security.acme.acceptTerms = true;
	services.nginx = {
		enable = true;
		recommendedProxySettings = true;
		recommendedTlsSettings = true;

		virtualHosts = {
			"chatbot.ggkbrian.com" = {
				locations."/" = {
					proxyPass = "http://127.0.0.1:43941";
					proxyWebsockets = true;
				};
				forceSSL = true;
				enableACME = true;
			};

			"ollama.ggkbrian.com" = {
				locations."/" = {
					proxyPass = "http://127.0.0.1:11434";
					proxyWebsockets = true;
					basicAuth = true;
					basicAuthFile = config.age.secrets."ollama-basic-auth".path;
					extraConfig = ''
						proxy_set_header Origin http://127.0.0.1:11434;
					'';
					recommendedProxySettings = false;
				};
				forceSSL = true;
				enableACME = true;
			};
		};
	};
	networking.firewall.allowedTCPPorts = [
		443 80
	];
}
