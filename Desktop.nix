{ config, pkgs, ... }:

{
	boot.kernelPackages = pkgs.linuxPackages_6_11;
	boot.kernelPatches = [ {
		name = "beyondfix";
		patch = ./beyond.patch;
	} ];

	networking.hostName = "BrianNixDesktop"; # Define your hostname.

# For logitech G29
	hardware.new-lg4ff.enable = true;
	hardware.usb-modeswitch.enable = true;

# Bg running services and daemons
	services.monado = {
		package = pkgs.monado;
		enable = true;
		highPriority = true;
		defaultRuntime = true;
	};
	
	systemd.user.services.monado.environment = {
		STEAMVR_LH_ENABLE = "1";
		# XRT_COMPOSITOR_COMPUTE = "1";
		# XRT_COMPOSITOR_SCALE_PERCENTAGE = "120";
		# WMR_HANDTRACKING = "0";
	};

	programs.gamemode = {
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

	# services.ollama.package = (pkgs.ollama.overrideAttrs { enableRocm = true; });
	services.ollama.acceleration = "rocm";
	
	services.openssh = {
		enable = true;
		ports = [ 4269 ];
		settings.AllowUsers = [ "brian" ];
		settings.PasswordAuthentication = false;
	};
	virtualisation.docker.enable = true;

# Games
	programs.gamescope = {
		enable = true;
		# capSysNice = true;
	};

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		# gamescopeSession.enable = false;
	};

# Clip last 30 seconds
	users.users.brian.packages =
		let gpu-screen-recorder = pkgs.gpu-screen-recorder.overrideAttrs (final: self: {
			postInstall = ''
			install -Dt $out/bin gpu-screen-recorder gsr-kms-server
			mkdir $out/bin/.wrapped
			mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
			makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
			--prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
			--suffix PATH : $out/bin
			'';
		}); in [ gpu-screen-recorder ];
	security.wrappers."gsr-kms-server" =
		let gpu-screen-recorder = pkgs.gpu-screen-recorder.overrideAttrs (final: self: {
			postInstall = ''
			install -Dt $out/bin gpu-screen-recorder gsr-kms-server
			mkdir $out/bin/.wrapped
			mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
			makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
			--prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
			--suffix PATH : $out/bin
			'';
		}); in {
		owner = "root";
		group = "root";
		capabilities = "cap_sys_admin+ep";
		source = "${gpu-screen-recorder}/bin/gsr-kms-server";
	};

# Special Rules
	networking.firewall.allowedTCPPorts = [ 4270 4269 ];
	networking.firewall.allowedUDPPorts = [ 4270 ];
}
