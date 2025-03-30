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
			"localhost" = {
				listen = [ {
					addr = "127.0.0.1";
					port = 8080;
					ssl = false;
				} ];
				root = inputs.portfolio.packages."x86_64-linux".portfolio-api + /public;
				extraConfig = ''
					index index.php;
					error_page 404 /index.php;
					add_header X-Frame-Options "SAMEORIGIN";
					add_header X-Content-Type-Options "nosniff";
				'';
				locations = {
					"/" = {
						tryFiles = "$uri $uri/ /index.php?$query_string";
					};
					"= /favicon.ico" = {
						extraConfig = ''
							access_log off;
							log_not_found off;
						'';
					};
					"= /robots.txt" = {
						extraConfig = ''
							access_log off;
							log_not_found off;
						'';
					};
					"~ ^/index\.php(/|$)" = {
						extraConfig = ''
							fastcgi_pass unix:${config.services.phpfpm.pools.portfolio.socket} ;
							# fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
							# include fastcgi_params;
							fastcgi_hide_header X-Powered-By;
						'';
					};
					# "~ /\.(?!well-known/).*" = {
					# 	extraConfig = "deny all;";
					# };
				};

			};
			"portfolio.ggkbrian.com" = {
				addSSL = true;
				enableACME = true;
				locations = {
					"/api/" = {
						proxyPass = "http://127.0.0.1:8080";
						recommendedProxySettings = true;
						extraConfig = ''
							rewrite ^/api/(.*)$ /$1 break ;
						'';
					};
					"/" = {
						root = inputs.portfolio.packages."x86_64-linux".portfolio-website;
						tryFiles = "$uri $uri/ =404";
					};
				};
			};
		};

	};


	services.portfolio-api = {
		enable = true;
		portfolio-pkgs = inputs.portfolio.packages."x86_64-linux".portfolio-api;
		debug = true;
		domain = "portfolio.ggkbrian.com";
	};

	# PHP
	services.phpfpm = {
		pools = {
			"portfolio" = {
				user = "portfolio";
				group = "portfolio";
				phpPackage = pkgs.php.withExtensions ({all, enabled}:
				enabled ++ (with all; [
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
					pgsql
				])
				);
				phpOptions = ''
					extension=pgsql
				'';

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
		authentication = pkgs.lib.mkForce ''
		#TYPE    DB        USER      ADDRESS          METHOD
		host     all       all       127.0.0.1/32     trust
		host     portfolio portfolio 127.0.0.1/32     trust
		local    all       all                        trust
		host     all       all       192.168.2.69/32  trust
		host     all       all       192.168.2.71/32  trust
		'';
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
