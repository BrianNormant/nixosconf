{ pkgs, ... }: 
{
	programs.zsh = {
		enable = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			ls    =  "lsd";
			l     =  "lsd -la";
			ll    =  "lsd -l";
			cd    =  "z";
			icat  =  "kitty +kitten icat --clear";
			lg    =  "lazygit";
			man   =  "batman";
			vim   =  "NVIM_APPNAME=nvim-simple  nvim";
			gg    =  "lazygit";
			man-php = let php-manual-html = pkgs.stdenv.mkDerivation {
				pname = "php-manual-en-html";
				version = "8.3@26-03-2024";

				src = pkgs.fetchurl {
					url = "https://www.php.net/distributions/manual/php_manual_en.tar.gz";
					hash = "sha256-Df7IsVjjsDPeLDSzKwm/EicmFGEXlTRQDLMAZZUT5WU=";
				};

				outputs = [ "out" ];

				postInstall = ''
					mkdir "$out"
					mv *.html "$out"
					'';
			}; in "find ${php-manual-html} -maxdepth 1 -type f -printf '%f\n' | fzf --reverse | xargs printf '${php-manual-html}/%s' | xargs lynx";
		};
		shellInit = ''


if [[ -n $TMUX ]]; then
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

	# fzf colorscheme
	export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#3c3836,bg:#fbf1c7,hl:#5f87af --color=fg+:#d65d0e,bg+:#fbf1c7,hl+:#076678 --color=info:#d79921,prompt:#cc241d,pointer:#076678 --color=marker:#79740e,spinner:#076678,header:#7c6f64'

	(( ! ''${+functions[p10k]} )) || p10k finalize
fi

eval "$(zoxide init zsh)"
# Function to autoload the correct CURRENT_PLAYER
function playerctl() {
	eval `systemctl --user show-environment | grep CURRENT_PLAYER`
	env playerctl -p "$CURRENT_PLAYER" $*
}

'';
	};
}
