# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, pkgs, ... }:

{
	nix.settings.trusted-users = [ "root" "brian" ];
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nix.registry = {
		nixpkgs.to = {
			type = "path";
			path = pkgs.path;
			narHash = builtins.readFile
				(pkgs.runCommandLocal "get-nixpkgs-hash"
				 { nativeBuildInputs = [ pkgs.nix ]; }
				 "nix-hash --type sha256 --sri ${pkgs.path} > $out");
		};
	};
	hardware.usb-modeswitch.enable = true;

# Screen sharing
	xdg.portal.wlr.enable = true;
	# xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-hyprland ];

# Use the recommanded option : systemd-boot
	boot.loader.systemd-boot.enable = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;
	nixpkgs.config.allowUnfree = true;
	nix.settings.sandbox = "relaxed";

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	security = {
		sudo.enable = true;
		doas.enable = true;
		doas.extraRules = [ {
			users = [ "brian" ];
			keepEnv = true;
			persist = true;
		} ];
	};


# nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# for gradle and jdtls
	programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [
		# For java swing
		fontconfig 
		noto-fonts
		# for zutty
		ucs-fonts
		xorg.libxcb
	];

# Pick only one of the below networking options.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

# Set your time zone.
	time.timeZone = "America/Montreal";

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

# Enable CUPS to print documents.
	services.printing.enable = true;
	services.avahi = {
		enable = true;
		nssmdns4 = true;
		openFirewall = true;
	};


# Enable sound with pipewire
	hardware.pulseaudio.enable = false;
	hardware.pulseaudio.support32Bit = true;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	services.pipewire.wireplumber.configPackages = [
		(pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
		 bluez_monitor.properties = {
		 ["bluez5.enable-sbc-xq"] = true,
		 ["bluez5.enable-msbc"] = true,
		 ["bluez5.enable-hw-volume"] = true,
		 ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
		 }
		 '')
	];

# Enable bluetooth
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
	};

	programs.thunar.enable = true;

	users.users.brian = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" "kvm" "adbusers" ]; # Enable ‘sudo’ for the user.
		shell = pkgs.zsh;
		packages = with pkgs; [
# Burautique
			onlyoffice-bin
			pavucontrol
			hyprpaper hyprshot hyprlock hypridle# Window manager
			cmus yt-dlp # picard # Music player, downloader and tagging
			vlc
			vesktop
			webcord-vencord
			btop
# Terminal Tools
			kitty # terminal emulators
#TODO ./zutty.nix
			lsd
			zoxide
			tldr
			dust
			fzf
			bat bat-extras.batman
			tree

			vifm
			lazygit
			nushell
			gh glab # Github and gitlab CLI tool
#Other
			copyq # clipboard manager
			dunst # notification daemom
			wob   # Ligthweight overlay to show volume changes
			playerctl
			appimage-run

			unison # File sync


# gaming
			prismlauncher
			gamemode

			winetricks
			wineWowPackages.wayland

		];
	};

# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs; [
		brightnessctl
		wget
		git
		curl
		lxqt.lxqt-policykit
		file
		acpi
		unzip
		p7zip
		fastfetch # Extrement important!!!
		bluez # bluetooth headphones
		bc
		sshfs
		lynx
		delta
		python3
		usb-modeswitch
		jq
		gamescope
	];
	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		mplus-outline-fonts.githubRelease
		dina-font
		proggyfonts
		(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
	];

# Programs enabled
	programs.dconf.enable = true;
	programs.adb.enable = true;
	programs.nh = {
		enable = true;
		clean.enable = true;
		# clean.extraArgs = "--keep-since 4d --keep 3";
		flake = "/home/brian/nixos-config";
	};

	programs.tmux = {
		enable = true;
		keyMode = "vi";
		plugins = [ pkgs.tmuxPlugins.gruvbox ];
		extraConfig = ( builtins.readFile ./tmux.conf );
	};

	programs.hyprland.enable = true;

	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

		withPython3 = true;
		configure = {
			customRC = ''
			luafile ${./nvim.lua}
			let g:gruvbox_italic=1
			let g:gruvbox_contrast_dark="soft"

			colorscheme gruvbox
			hi CurrentWord cterm=underline
			hi CurrentWordTwins cterm=underline
			'';
			packages.myVimPackage = with pkgs.vimPlugins; {
				opt = [];
				start = [
					gruvbox
					comment-nvim
					vim-surround
					vim_current_word
					vim-wordy
				];
			};
		};
	};

	environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron to use wayland:

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
				mangohud
			];
		};
	};

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.05"; # Did you read the comment?
}

