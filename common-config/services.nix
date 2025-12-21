{pkgs, lib, ...}:
{
	services = {
		pipewire = {
			enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
			pulse = {
				enable = true;
			};
			wireplumber = {
				configPackages = [
					(pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
					 bluez_monitor.properties = {
					 ["bluez5.enable-sbc-xq"] = true,
					 ["bluez5.enable-msbc"] = true,
					 ["bluez5.enable-hw-volume"] = true,
					 ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
					 }
					 '')
				];
			};
		};
	};
	programs = {
		dconf = {
			enable = true;
		};
		mtr = {
			enable = true;
		};
		gnupg = {
			agent = {
				enable = true;
				enableSSHSupport = true;
			};
		};
	};
}
