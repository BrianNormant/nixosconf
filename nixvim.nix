{ pkgs, lib, config, inputs, ... }:
let
	helpers = config.lib.nixvim;
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchFromGitHub;
	inherit (pkgs) fetchgit;
in {
	programs.nixvim = {
		enable = true;
		vimAlias = true;
		colorscheme = "gruvbox-material";
		luaLoader.enable = true;
		clipboard.register = "unnamedplus";

		plugins = {
			mini = {
				enable = true;
				modules = {
					comment = {
						mappings = {
							comment = "gc";
							comment_line = "gcc";
							comment_visual = "gc";
							textobject = "gc";
						};
					};
					surround = {
						highlight_duration = 200;
						mappings = {
							add = "sa";
							delete = "sd";
							find = "sf";
							find_left = "sF";
							highlight = "sh";
							replace = "sr";
							update_n_lines = "sn";

							suffix_last = "l";
							suffix_next = "n";
						};
					};
					align = {
						mappings = {
							start = "ga";
							start_with_preview = "gA";
						};
					};
					move = {
						mappings = {
							left = "<M-h>";
							right = "<M-l>";
							down = "<M-j>";
							up = "<M-k>";
							line_left = "<M-h>";
							line_right = "<M-l>";
							line_down = "<M-j>";
							line_up = "<M-k>";
						};
					};
					pairs = {};
					bracketed = {};
					notify = {
						lsp_progress = { enabled = false; };
						window = {winblend = 0;};
					};
					cursorword = { delay = 200; };
				};
			};
		};

		extraPlugins = with pkgs.vimPlugins; [
			gruvbox-material-nvim
			(buildVimPlugin rec {
				pname = "nvim-startup";
				version = "v0.6.0";
				src = fetchgit {
					url = "https://git.sr.ht/~henriquehbr/nvim-startup.lua";
					tag = version;
					hash = "sha256-96XvHPUzFN7ehUXTV+0+dBPdVej+57icuECRVYMqZaA";
				};
			})
		];
		extraConfigLua = builtins.readFile ./nixvim.lua;
	};
}
