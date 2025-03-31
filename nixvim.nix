{ pkgs, lib, config, inputs, ... }:
let
	helpers = config.lib.nixvim;
in {
	programs.nixvim = {
		enable = true;
		vimAlias = true;
		colorscheme = "gruvbox";
	};
}
