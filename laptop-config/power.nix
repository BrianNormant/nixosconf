{pkgs, ...}: {
	powerManagement = {
		enable = true;
		powertop = {
			enable = true;
		};
		powerDownCommands = with pkgs; ''
		${kmod}/bin/modprobe -r ath11k_pci
		'';
		powerUpCommands = with pkgs; ''
		${kmod}/bin/modprobe ath11k_pci
		'';
	};
}
