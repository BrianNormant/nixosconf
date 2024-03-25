{ pkgs, ... }:
{
	boot.kernelPatches = [ {
		name = "beyondfix";
		patch = ./beyond.patch;
	} ];

# For logitech G29
	hardware.new-lg4ff.enable = true;
	hardware.usb-modeswitch.enable = true;


# Bg running services and daemons
	services.ollama = {
		enable = true;
		acceleration = "rocm";
	};
	services.openssh = {
		enable = true;
		ports = [ 4269 ];
		settings.AllowUsers = [ "brian" ];
		settings.PasswordAuthentication = false;
	};
	virtualisation.docker.enable = true;


# Games
	programs.gamescope.enable = true;
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		gamescopeSession.enable = false;
	};
	nixpkgs.config.packageOverrides = pkgs: {
		steam = pkgs.steam.override {
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
				
				gamemode
				mangohud
			];
		};
	};

# Special Rules
	networking.firewall.allowedTCPPorts = [ 4269 ];
	# networking.firewall.allowedUDPPorts = [];
}
