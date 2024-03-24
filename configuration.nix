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

	networking.hostName = "BrianNixDesktop"; # Define your hostname.


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
		programs.neovim = {
			enable = true;
			withPython3 = true;
			extraPackages = with pkgs; [
				jdt-language-server
				ccls
				phpactor
				ripgrep
				fswatch
				fd
				yarn nodejs_21
				gdb
				lua-language-server
				nil
				oracle-instantclient
			];
			plugins = with pkgs.vimPlugins; [

					{ plugin = dressing-nvim;
					  config = "lua require(\"dressing\").setup {}"; }
					{ plugin = gruvbox-nvim; 
					  config = "lua require('gruvbox').setup { contrast = 'soft'}"; }
					{ plugin = tabby-nvim;
					  config = "lua require('tabby').setup {}"; }
					{ plugin = dropbar-nvim;
					  config = "lua require('dropbar').setup {}"; }
					ccc-nvim
					# { plugin = modicator-nvim;
					#   config = "lua require('modicator').setup {}"; }
					{ plugin = gitsigns-nvim;
					  config = "lua require('gitsigns').setup {}"; }

					{ plugin = lualine-nvim;
					  config = (builtins.readFile ./bar.vim);}
					# Qol
					{ plugin = comment-nvim;
					  config = "lua require('Comment').setup {}";}
					vim-surround
					vim-repeat
					vim-lastplace
					{ plugin = leap-nvim;
					  config=''
hi LeapBackdrop guifg=#888888
hi LeapLabelPrimary guifg=#FF0000
lua require 'leap'.create_default_mappings()
					'';}
					{ plugin = nvim-autopairs;
					  config = "lua require 'nvim-autopairs'.setup {}";}
					{ plugin = boole-nvim;
					  config = ''
lua << EOF
require 'boole'.setup {
	mappings = {
		increment = '<C-a>',
		decrement = '<C-x>',
	}
}
EOF
					'';}
					{ plugin = registers-nvim;
					  config = "lua require 'registers'.setup {}"; }
					{ plugin = marks-nvim;
					  config = "lua require 'marks'.setup {}"; }
					{ plugin = indent-blankline-nvim;
					  config = ''
lua << EOF
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { 
	indent = { highlight = highlight }, 
	scope = { enabled=true, highlight = highlight } 
}
EOF

					'';}
					{ plugin = guess-indent-nvim;
					  config = "lua require'guess-indent'.setup {}";}
					{ plugin = vim_current_word;
					  config = ''
hi CurrentWord gui=underline guibg=#00000000
hi CurrentWordTwings gui=underline,bold
					''; }
					# Features
					telescope-lsp-handlers-nvim
					{ plugin = telescope-nvim;
					  config = ''
lua << EOF
local telescope = require "telescope"
telescope.setup {
	defaults = {
		layout_strategy = "flex",
	},
}
telescope.load_extension('lsp_handlers')
EOF
					'';}
					vim-wakatime
					{ plugin = nvim-web-devicons;
					  config = ''
lua require("nvim-web-devicons").setup {}
					''; }
					{ plugin = ( pkgs.vimUtils.buildVimPlugin {
						pname = "icon-picker-nvim";
						version = "HEAD";
						src = pkgs.fetchFromGitHub {
							owner = "ziontee113";
							repo = "icon-picker.nvim";
							rev = "HEAD";
							sha256 = "VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
						};
					} );
					  config = "lua require('icon-picker').setup {}";}
					lazygit-nvim
					compiler-explorer-nvim
					{ plugin = ( pkgs.vimUtils.buildVimPlugin {
						pname = "muren-nvim";
						version = "HEAD";
						src = pkgs.fetchFromGitHub {
							owner = "AckslD";
							repo = "muren.nvim";
							rev = "b6484a1";
							sha256 = "hv8IfNJ+3O1L1PPIZlPwXc37Oa4u8uZPJmISLnNkBGw=";
						};
						} );
						config = "lua require('muren').setup {}"; }
					{ plugin = oil-nvim;
					  config = "lua require('oil').setup {}";}
					{ plugin = coq_nvim;
					  config = ''
lua << EOF
local coq = require 'coq'
vim.g.coq_settings = {
	["xdg"] = true,
	["clients.tabnine.enabled"] = true,
}
EOF
					'';}
					coq-artifacts
					coq-thirdparty

					# LSP
					{ plugin = symbols-outline-nvim;
					  config = "lua require 'symbols-outline'.setup {}"; }
					{ plugin = lsp_lines-nvim;
					  config = ''
lua << EOF
require 'lsp_lines'.setup {}
vim.diagnostic.config {
	virtual_text = false
}
EOF
					''; }
					{ plugin = actions-preview-nvim;
					  config = "lua require 'actions-preview'.setup {}";}
					# lsp
					{ plugin = nvim-lspconfig;
					  config = ''
lua << EOF
local coq = require 'coq'
local lspconfig = require('lspconfig')
local common_config = {
	coq.lsp_ensure_capabilities(),
}

lspconfig.ccls.setup(common_config)
lspconfig.lua_ls.setup(common_config)
lspconfig.nil_ls.setup(common_config)
lspconfig.phpactor.setup(common_config)
EOF
					   '';}
					   nvim-dap
					   { plugin = nvim-dap-ui;
					   	 config = (builtins.readFile ./dap.vim); }
					   { plugin = ( pkgs.vimUtils.buildVimPlugin {
					   		pname = "gen-nvim";
							version = "HEAD";
							src = pkgs.fetchFromGitHub {
								owner = "David-Kunz";
								repo = "gen.nvim";
								rev = "2cb643b";
								sha256 = "aZ/ZMmatoIXnY3qtRjUqJStlpg0VGbJ1XdRjyDMhHqU=";
							};
						} );
						  config = "lua require 'gen'.setup { model = 'mistral' }"; }
						{ plugin = nvim-jdtls;
						  config = ''
lua << EOF
local jdtls = require 'jdtls'
local config = {
	cmd = {
		'${pkgs.jdt-language-server}/bin/jdtls'
	},
	settings = {
		java = {
			configuration = {
				runtimes = {
					{name = "JavaSE-17", path = "~/.gradle/jdks/eclipse_adoptium-17-amd64-linux/jdk-17.0.10+7/"},
					{name = "JavaSE-21", path = "~/.gradle/jdks/eclipse_adoptium-21-amd64-linux/jdk-21.0.2+13/"},
				}
			}
		},
	},

	root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew'}),
}

vim.api.nvim_create_autocmd(
	'BufEnter',
	{ 	pattern = {'*.java'},
		callback = function() jdtls.start_or_attach(config) end,
	})
EOF
							''; }

						# DataBase
						vim-dadbod-ui
						{ plugin = vim-dadbod;
						  config = ''
lua << EOF
vim.g.db_ui_use_nerd_fonts = 1
vim.g.dbs = {
	['DB Oracle locale'] = "oracle://SYSTEM:welcome123@localhost:1521/FREE"
}
EOF
						  ''; }
						# Markdown
						markdown-preview-nvim

						{ plugin = legendary-nvim;
						  config = ( builtins.readFile ./legend.vim ); }

			];
			extraLuaConfig = ''			
vim.opt.clipboard:append "unnamedplus"
vim.opt.scrolloff = 5
vim.o.laststatus = 3

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- set to true to use space instead of tab

vim.o.cursorline = true
vim.o.number = true
vim.o.relativenumber = true

vim.cmd "colorscheme gruvbox"
vim.cmd "COQnow"
			'';
		};
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

	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;

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
				start = [
					gruvbox
					comment-nvim
					vim-surround
					vim_current_word
					vim-wordy
				];
				opt = [];
			};
		};
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
			];
		};
	};
# Overlays
	nixpkgs.overlays = [
		(import (builtins.fetchTarball {
			 url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
			 }))
	(final: prev: {
	 rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
	 })
	];


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

