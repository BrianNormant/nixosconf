{ pkgs, pkgs-stable, ...}: {
	boot.kernelPackages = pkgs.linuxPackages_6_13;
	boot.kernelPatches = [
	{
		name = "beyondfix";
		patch = ./beyond.patch;
	}
	{
		name = "amdgpu-ignore-ctx-privileges";
		patch = pkgs.fetchpatch {
			name = "cap_sys_nice_begone.patch";
			url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
			hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
		};
	}
	];

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
		XRT_COMPOSITOR_DESIRED_MODE = "0"; # 0 for 2560*2560 | 1 for 1920 * 1920
		XRT_COMPOSITOR_SCALE_PERCENTAGE = "100";
		# XRT_COMPOSITOR_COMPUTE = "1";
		# WMR_HANDTRACKING = "0";
	};

	services.open-webui = {
		enable = false; # Still buggy
		port = 3000;
		environment = {
			OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
			WEBUI_AUTH = "False";
		};
		openFirewall = true;
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

	services.ollama = {
		enable = true;
		user = "ollama";
		acceleration = "rocm";
		rocmOverrideGfx = "11.0.0";
		loadModels = [
			"deepseek-r1:14b"
				"gemma3:27b"
				"dolphin-mistral"
		];
		environmentVariables = {
			"OLLAMA_ORIGINS" = "*";
		};
		openFirewall = true;
		host = "0.0.0.0";
	};

	services.nextjs-ollama-llm-ui = {
		enable = true;
		port = 43941;
		hostname = "0.0.0.0";
	};

	services.openssh = {
		enable = true;
		ports = [ 4269 ];
		settings.AllowUsers = [ "brian" ];
		settings.PasswordAuthentication = false;
	};
	virtualisation.docker.enable = false;

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
	networking.firewall.enable = true;
	networking.firewall.allowedTCPPorts = pkgs.lib.mkForce [ 4270 4269 43941 11434 ];
	networking.firewall.allowedUDPPorts = [ 4270 ];
}
