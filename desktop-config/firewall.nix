{...}:
{
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 4270 4269 ];
		allowedUDPPorts = [ 4270 ];
	};
}
