{pkgs, lib, ...}:
{
	networking = {
		networkmanager = {
			enable = true;
			plugins = with pkgs; [ networkmanager-openvpn ];
		};
	};
}
