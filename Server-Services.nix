{pkgs, ...}: {

	# Webserver
	security.acme.acceptTerms = true;
	security.acme.defaults.email = "briannormant@gmail.com";
	services.httpd = {
		enable = true;
		adminAddr = "briannormant@gmail.com";
		enablePHP = true;
		virtualHosts = {
			"ggkbrian.com" = {
				documentRoot = "/var/www/main";
				addSSL = true;
				enableACME = true;
			};
			"tch057.ggkbrian.com" = {
				documentRoot = "/var/www/tch057";
				addSSL = true;
				enableACME = true;
			};
			"portfolio.ggkbrian.com" = {
				documentRoot = "/var/www/portfolio";
				addSSL = true;
				enableACME = true;
			};
		};
	};

	# Local DB
	services.postgresql =
		let txt = pkgs.writeTextFile {
				name = "postgresinit.sql";
				text = ''
				ALTER ROLE tch057 WITH PASSWORD '1234';
				'';
				};
	in {
		enable = true;
		enableJIT = true;
		ensureDatabases = [ "tch057" ];
		ensureUsers = [
		{
			name = "tch057";
			ensureClauses.createdb = true;
			ensureDBOwnership = true;
		}
		];
		initialScript = txt;
	};
}
