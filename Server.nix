{ inputs, pkgs, ...} : {
	nix = {
		settings = {
			trusted-users = [ "root" "brian" ];
			experimental-features = [ "nix-command" "flakes" ];
		};
		registry = {
			nixpkgs.flake = inputs.nixpkgs-stable;
		};
	};

	boot.loader.systemd-boot.enable = true;

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	security = {
		sudo.enable = true;
	};

	time.timeZone = "America/Montreal";


	users.users.server = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" "kvm" ];
	};

	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		# package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

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

	services.openssh.enable = true;
	services.openssh = {
		settings.AllowUsers = [ "server" ];
		settings.PasswordAuthentication = false;
	};

	virtualisation.docker.enable = true;
	networking = {
		firewall.allowedTCPPorts = [ 443 80 22 ];
		firewall.allowedUDPPorts = [ ];
		hostName = "BrianNixServer";
	};

	system.stateVersion = "23.11";
}
