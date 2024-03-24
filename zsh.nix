{ pkgs, ... }: {
	programs.zsh = {
		enable = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ls = "lsd";
			l = "lsd -la";
			ll = "lsd -l";
			cd = "z";
			icat = "kitty +kitten icat --clear";
			lg = "lazygit";
			man = "batman";
			vim = "NVIM_APPNAME=nvim-simple nvim";
		};
		shellInit = ''

source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Disable zsh-autocomplete keybinds
() {
   local -a prefix=( '\e'{\[,O} )
   local -a up=( ''${^prefix}A ) down=( ''${^prefix}B )
   local key=
   for key in $up[@]; do
      bindkey "$key" up-line-or-history
   done
   for key in $down[@]; do
      bindkey "$key" down-line-or-history
   done
}
bindkey '^R' .history-incremental-search-backward
bindkey '^S' .history-incremental-search-forward

source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
source ${(pkgs.fetchFromGitHub {
	owner = "chisui";
	repo = "zsh-nix-shell";
	rev = "v0.8.0";
	sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
})}/nix-shell.plugin.zsh

source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
	source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"
(( ! ''${+functions[p10k]} )) || p10k finalize
'';
	};
}
