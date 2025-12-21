{pkgs, config, main-user, ...}:
{
	users.users."${main-user}".extraGroups = [ "gamemode" ];
	programs = {
	#=================================[ Gamemode ]=================================
		gamemode = {
			enable = true;
			settings = {
				general = {
					renice = 10;
				};
				gpu = {
					apply_gpu_optimisations = "accept_responsibility";
					gpu_device = 1; # 0 is igpu, 1 is dedicated
					amd_performance_level = "high";
				};
			};
		};
	#================================[ Gamescope ]===================================
		gamescope = {
			enable = true;
			capSysNice = true;
		};

	#================================[ Steam ]===================================
		steam = {
			enable = true;
			package = pkgs.steam.override {
				extraPkgs = pkgs: with pkgs; [
					xorg.libXcursor
					xorg.libXi
					xorg.libXinerama
					xorg.libXScrnSaver
					libpng
					libpulseaudio
					libvorbis
					stdenv.cc.cc.lib
					libkrb5
					keyutils
					libxml2
					mangohud
					SDL2
					gamescope
				];
			};
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
			extraCompatPackages = with pkgs; [
				proton-ge-bin
				gamescope
			];
		};
	};
}
