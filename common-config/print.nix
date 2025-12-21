{pkgs, lib, ...}:
{
	services = {
		printing = {
			enable = true;
			drivers = with pkgs; [
				cups-brother-mfcl2750dw
			];
		};
		# We need Avahi to find the printer on the network.
		avahi = {
			enable = true;
			nssmdns4 = true;
			openFirewall = true;
		};
	};
}
