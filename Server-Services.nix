{pkgs, inputs, config,  ...}: {
	# To rebuild the server remotly run: ```
	# nixos-rebuild switch --flake .#BrianNixServer --target-host RootNixServer
	# ```

	services.nginx = {
		enable = true;
		virtualHosts = {
			# Proxy to access ollama and ollama UI
			"ollama.ggkbrian.com" = {
				addSSL = true;
				enableACME = true;
				locations."/" = {
					proxyPass = "http://192.168.2.71:11434";
					recommendedProxySettings = true;
				};
			};
			"chatbot.ggkbrian.com" = {
				addSSL = true;
				enableACME = true;
				locations."/" = {
					proxyPass = "http://192.168.2.71:43941";
					recommendedProxySettings = true;
				};
			};
			# Webservers
			"ggkbrian.com" = {
				addSSL = true;
				enableACME = true;
				locations."/" = {
					root = "/var/www/main";
				};
			};
			"tch057.ggkbrian.com" = {
				addSSL = true;
				enableACME = true;
				locations."/" = {
					root = "/var/www/tch057";
				};
			};
			"portfolio.ggkbrian.com" = {
				addSSL = true;
				enableACME = true;
				locations = {
					"/" = {
						root = inputs.portfolio.packages."x86_64-linux".portfolio-website;
					};
					"/api/" = {
						root = inputs.portfolio.packages."x86_64-linux".portfolio-api + /public;
						# TODO: configure 404 endpoint
						extraConfig = ''
							rewrite ^/api/(.*)$ /$1 break ;
							fastcgi_pass unix:${config.services.phpfpm.pools.portfolio.socket} ;
							fastcgi_index index.php ;

							fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
							include ${pkgs.nginx}/conf/fastcgi_params;
							include ${pkgs.nginx}/conf/fastcgi.conf
						'';
							# Header always append X-Frame-Options "SAMEORIGIN" ;
							# Header always set X-XSS-Protection "1; mode=block" ;
							# Header always set X-Content-Type-Options "nosniff" ;
					};
				};
			};
		};

	};

	# PHP
	services.phpfpm = {
		pools = {
			"portfolio" = {
				user = "nobody";
				group = "nogroup";
				phpPackage = pkgs.php.withExtensions ({all, ...}:
				with all; [
					ctype
					curl
					dom
					fileinfo
					filter
					mbstring
					openssl
					pdo
					session
					tokenizer
					xml
				]
				);
				settings = {
					"listen.owner" = config.services.nginx.user;
					"listen.group" = config.services.nginx.group;

					"pm" = "dynamic";
					"pm.max_children" = 8;
					"pm.start_servers" = 2;
					"pm.min_spare_servers" = 2;
					"pm.max_spare_servers" = 4;
					"pm.max_requests" = 500;
					"request_terminate_timeout" = 300;
				};
			};
		};
	};

	# Webserver
	security.acme.acceptTerms = true;
	security.acme.defaults.email = "briannormant@gmail.com";

	# Local DB
	services.postgresql =
		let txt = pkgs.writeTextFile {
				name = "postgresinit.sql";
				# maybe use this? https://github.com/NixOS/nixpkgs/pull/326306
				text = ''
				ALTER ROLE tch057 WITH PASSWORD '1234';
				ALTER ROLE portfolio WITH PASSWORD '1234';
				'';
				};
	in {
		enable = true;
		enableJIT = true;
		ensureDatabases = [ "tch057" "portfolio" ];
		ensureUsers = [
		{
			name = "tch057";
			ensureDBOwnership = true;
		}
		{
			name = "portfolio";
			ensureDBOwnership = true;
		}
		];
		initialScript = txt;
	};
}
