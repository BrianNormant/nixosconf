{pkgs, lib, ...}:
{
	# log-in avec vpn de l'ets:
	programs.nm-applet = {
		enable = true;
	};
	networking = {
		networkmanager = {
			enable = true;
			plugins = with pkgs; [ networkmanager-openvpn ];
			ensureProfiles = {
				profiles = {
					"etsVPN" = {
						connection = {
							id = "ETSVPN";
							type = "vpn";
						};
						vpn = {
							user-name = "brian.normant.1@ens.etsmtl.ca";
							service-type = "openconnect";
							data = "cookie-flags=2,gateway=accesvpn.etsmtl.ca,protocol=anyconnect,useragent=AnyConnect";
							secrets = "gateway=accesvpn.etsmtl.ca,gwcert=";
						};
					};
				};
			};
		};
		firewall = {
			allowedTCPPorts = [];
			allowedUDPPorts = [];
		};
	};
}
