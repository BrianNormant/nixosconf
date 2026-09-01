{ config, pkgs, ... }:

{
	security.acme.acceptTerms = true;
	services.nginx = {
		enable = true;
		recommendedProxySettings = true;
		recommendedTlsSettings = true;

		virtualHosts = {
			"chatbot.ggkbrian.com" = {
				locations."/" = {
					proxyPass = "http://127.0.0.1:43941";
				};
				forceSSL = true;
				enableACME = true;
			};

			"ollama.hostname.com" = {
				locations."/" = {
					proxyPass = "http://127.0.0.1:11434";
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
