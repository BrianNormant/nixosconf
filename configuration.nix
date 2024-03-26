# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
		<home-manager/nixos>
		./localimport.nix

		./zsh.nix
		./nvim.nix
	];

# Use the recommanded option : systemd-boot
	boot.loader.systemd-boot.enable = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;

	hardware.opengl = {
		enable = true;
		extraPackages = with pkgs; [
			libGL
			vaapiVdpau
			libva
		];
		driSupport = true;
		driSupport32Bit = true;
		setLdLibraryPath = true;
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

	nixpkgs.config.allowUnfree = true;
	nix.settings.sandbox = "relaxed";
# nix.settings.experimental-features = [ "nix-command" "flakes" ];

	programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [];

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


# Enable sound with pipewire
	hardware.pulseaudio.enable = false;
	hardware.pulseaudio.support32Bit = true;
	sound.enable = false;
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

	users.users.brian = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
		shell = pkgs.zsh;
		packages = with pkgs; [
# Burautique
			onlyoffice-bin
			hyprland hyprpaper hyprshot # Window manager
			cmus
			vesktop
			webcord-vencord
			btop
			xfce.thunar
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
			oterm
#Other
			copyq # clipboard manager
			dunst # notification daemom
			wob   # Ligthweight overlay to show volume changes
			rofi-wayland rofi-calc # Menu for desktop
			playerctl
			appimage-run

# gaming
			prismlauncher
		];
	};
	home-manager = {
		useUserPackages = true;
		useGlobalPkgs = true;
	};
	home-manager.users.brian = { pkgs, ...}: {
		home.packages = with pkgs; [
			waybar
			cava

			#dev:
			jetbrains.idea-community-src
			android-studio

			];
		home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";

		home.stateVersion = "23.11";
		xdg.portal.configPackages = [ pkgs.xdg-desktop-portal-gtk ];

		gtk = {
			enable = true;
			theme = {
				name = "gruvbox-dark";
				package = pkgs.gruvbox-dark-gtk;
			};
			cursorTheme = {
				name = "phinger-cursors";
				package = pkgs.phinger-cursors;
				size = 16;
			};
		};

		programs.git = {
			enable = true;
			userName = "BrianNixDesktop";
			userEmail = "briannormant@gmail.com";
		};

		programs.firefox.enable = true;
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
		neofetch # Extrement important!!!
		bluez # bluetooth headphones
		bc
		sshfs
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


	programs.tmux = {
		enable = true;
		keyMode = "vi";
		plugins = [ pkgs.tmuxPlugins.gruvbox ];
		extraConfig = ( builtins.readFile ./tmux.conf );
	};

	programs.hyprland.enable = true;
	programs.git.enable = true;

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

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# I guess it's easier to put in a git repo, making rollbacking changes even easier
	system.copySystemConfiguration = true;

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
	system.stateVersion = "23.11"; # Did you read the comment?
}

