{...}:
{
	networking.firewall = {
		enable = true;
		allowedTCPPorts = [ 4270 4269 43941 11434 ];
		allowedUDPPorts = [ 4270 ];
	};
}
