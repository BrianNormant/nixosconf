{ pkgs, ... }:
let
	inherit (pkgs.vimUtils) buildVimPlugin;
	inherit (pkgs) fetchgit;
in {
	programs.nixvim = {
		enable = true;
		vimAlias = true;
		colorscheme = "gruvbox-material";
		luaLoader.enable = true;
		clipboard.register = "unnamedplus";
		autoCmd = [
			{
				command = "!rm /tmp/nvim-startuptime";
				event = [ "VimLeavePre" ];
				pattern = [ "*" ];
			}
		];
		plugins = {
			mini = {
				enable = true;
				modules = {
					pick = {};
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
				luaConfig.post = ''
					vim.keymap.set("n", "<space>ff", "<cmd>Pick files<cr>",     {silent = true})
					vim.keymap.set("n", "<space>fF", "<cmd>Pick grep_live<cr>", {silent = true})
					vim.keymap.set("n", "<space>fb", "<cmd>Pick buffers<cr>",   {silent = true})
					vim.keymap.set("n", "<space>fh", "<cmd>Pick help<cr>",      {silent = true})
				'';
			};
		};

		extraPlugins = with pkgs.vimPlugins; [
			gruvbox-material-nvim
		];
		extraConfigLua = builtins.readFile ./config-files/nixvim.lua;
	};
}
