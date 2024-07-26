{ pkgs, ... }: 
{
	programs.zsh = {
		enable = true;
		autosuggestions.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			rimsort = "nix run github:vinnymeller/nixpkgs/init-rimsort#rimsort --extra-experimental-features 'nix-command flakes' --impure";
			ls    =  "lsd";
			l     =  "lsd -la";
			ll    =  "lsd -l";
			cd    =  "z";
			icat  =  "kitty +kitten icat --clear";
			lg    =  "lazygit";
			man   =  "batman";
			vim   =  "NVIM_APPNAME=nvim-simple  nvim";
			gg    =  "lazygit";
			ggpur = "ggu";
			g = "git";
			ga = "git add";
			gaa = "git add --all";
			gapa = "git add --patch";
			gau = "git add --update";
			gav = "git add --verbose";
			gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message \"--wip-- [skip ci]\"";
			gam = "git am";
			gama = "git am --abort";
			gamc = "git am --continue";
			gamscp = "git am --show-current-patch";
			gams = "git am --skip";
			gap = "git apply";
			gapt = "git apply --3way";
			gbs = "git bisect";
			gbsb = "git bisect bad";
			gbsg = "git bisect good";
			gbsn = "git bisect new";
			gbso = "git bisect old";
			gbsr = "git bisect reset";
			gbss = "git bisect start";
			gbl = "git blame -w";
			gb = "git branch";
			gba = "git branch --all";
			gbd = "git branch --delete";
			gbD = "git branch --delete --force";
			gbgd = "LANG=C git branch --no-color -vv | grep \": gone\\]\" | cut -c 3- | awk '\"'\"'{print $1}'\"'\"' | xargs git branch -d";
			gbgD = "LANG=C git branch --no-color -vv | grep \": gone\\]\" | cut -c 3- | awk '\"'\"'{print $1}'\"'\"' | xargs git branch -D";
			gbm = "git branch --move";
			gbnm = "git branch --no-merged";
			gbr = "git branch --remote";
			ggsup = "git branch --set-upstream-to=origin/$(git_current_branch)";
			gbg = "LANG=C git branch -vv | grep \": gone\\]\"";
			gco = "git checkout";
			gcor = "git checkout --recurse-submodules";
			gcb = "git checkout -b";
			gcB = "git checkout -B";
			gcd = "git checkout $(git_develop_branch)";
			gcm = "git checkout $(git_main_branch)";
			gcp = "git cherry-pick";
			gcpa = "git cherry-pick --abort";
			gcpc = "git cherry-pick --continue";
			gclean = "git clean --interactive -d";
			gcl = "git clone --recurse-submodules";
			gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";
			gcam = "git commit --all --message";
			gcas = "git commit --all --signoff";
			gcasm = "git commit --all --signoff --message";
			gcs = "git commit --gpg-sign";
			gcss = "git commit --gpg-sign --signoff";
			gcssm = "git commit --gpg-sign --signoff --message";
			gcmsg = "git commit --message";
			gcsm = "git commit --signoff --message";
			gc = "git commit --verbose";
			gca = "git commit --verbose --all";
			"gca!" = "git commit --verbose --all --amend";
			"gcan!" = "git commit --verbose --all --no-edit --amend";
			"gcans!" = "git commit --verbose --all --signoff --no-edit --amend";
			"gcann!" = "git commit --verbose --all --date=now --no-edit --amend";
			"gc!" = "git commit --verbose --amend";
			"gcn!" = "git commit --verbose --no-edit --amend";
			gcf = "git config --list";
			gdct = "git describe --tags $(git rev-list --tags --max-count=1)";
			gd = "git diff";
			gdca = "git diff --cached";
			gdcw = "git diff --cached --word-diff";
			gds = "git diff --staged";
			gdw = "git diff --word-diff";
			gdt = "git diff-tree --no-commit-id --name-only -r";
			gf = "git fetch";
			gfa = "git fetch --all --prune --jobs=10";
			gfo = "git fetch origin";
			gga = "git gui citool --amend";
			ghh = "git help";
			glgg = "git log --graph";
			glgga = "git log --graph --decorate --all";
			glgm = "git log --graph --max-count=10";
			glods = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\" --date=short";
			glod = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset\"";
			glola = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --all";
			glols = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\" --stat";
			glol = "git log --graph --pretty=\"%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
			glo = "git log --oneline --decorate";
			glog = "git log --oneline --decorate --graph";
			gloga = "git log --oneline --decorate --graph --all";
			glp = "_git_log_prettily";
			glg = "git log --stat";
			glgp = "git log --stat --patch";
			gignored = "git ls-files -v | grep \"^[[:lower:]]\"";
			gfg = "git ls-files | grep";
			gm = "git merge";
			gma = "git merge --abort";
			gmc = "git merge --continue";
			gms="git merge --squash";
			gmom = "git merge origin/$(git_main_branch)";
			gmum = "git merge upstream/$(git_main_branch)";
			gmtl = "git mergetool --no-prompt";
			gmtlvim = "git mergetool --no-prompt --tool=vimdiff";
			gl = "git pull";
			gpr = "git pull --rebase";
			gprv = "git pull --rebase -v";
			gpra = "git pull --rebase --autostash";
			gprav = "git pull --rebase --autostash -v";
			gluc = "git pull upstream $(git_current_branch)";
			glum = "git pull upstream $(git_main_branch)";
			gp = "git push";
			gpd = "git push --dry-run";
			"gpf!" = "git push --force";
			gpf = "git push --force-with-lease --force-if-includes";
			gpsup = "git push --set-upstream origin $(git_current_branch)";
			gpsupf = "git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes";
			gpv = "git push --verbose";
			gpoat = "git push origin --all && git push origin --tags";
			gpod = "git push origin --delete";
			ggpush = "git push origin \"$(git_current_branch)\"";
			gpu = "git push upstream";
			grb = "git rebase";
			grba = "git rebase --abort";
			grbc = "git rebase --continue";
			grbi = "git rebase --interactive";
			grbo = "git rebase --onto";
			grbs = "git rebase --skip";
			grbd = "git rebase $(git_develop_branch)";
			grbm = "git rebase $(git_main_branch)";
			grbom = "git rebase origin/$(git_main_branch)";
			grf = "git reflog";
			gr = "git remote";
			grv = "git remote --verbose";
			gra = "git remote add";
			grrm = "git remote remove";
			grmv = "git remote rename";
			grset = "git remote set-url";
			grup = "git remote update";
			grh = "git reset";
			gru = "git reset --";
			grhh = "git reset --hard";
			grhk = "git reset --keep";
			grhs = "git reset --soft";
			gpristine = "git reset --hard && git clean --force -dfx";
			gwipe = "git reset --hard && git clean --force -df";
			groh = "git reset origin/$(git_current_branch) --hard";
			grs = "git restore";
			grss = "git restore --source";
			grst = "git restore --staged";
			grev = "git revert";
			greva = "git revert --abort";
			grevc = "git revert --continue";
			grm = "git rm";
			grmc = "git rm --cached";
			gcount = "git shortlog --summary --numbered";
			gsh = "git show";
			gsps = "git show --pretty=short --show-signature";
			gstall = "git stash --all";
			gstaa = "git stash apply";
			gstc = "git stash clear";
			gstd = "git stash drop";
			gstl = "git stash list";
			gstp = "git stash pop";
			gsta = "git stash push";
			gsts = "git stash show --patch";
			gst = "git status";
			gss = "git status --short";
			gsb = "git status --short --branch";
			gsi = "git submodule init";
			gsu = "git submodule update";
			gsd = "git svn dcommit";
			gsr = "git svn rebase";
			gsw = "git switch";
			gswc = "git switch --create";
			gswd = "git switch $(git_develop_branch)";
			gswm = "git switch $(git_main_branch)";
			gta = "git tag --annotate";
			gts = "git tag --sign";
			gtv = "git tag | sort -V";
			gignore = "git update-index --assume-unchanged";
			gunignore = "git update-index --no-assume-unchanged";
			gwch = "git whatchanged -p --abbrev-commit --pretty=medium";
			gwt = "git worktree";
			gwta = "git worktree add";
			gwtls = "git worktree list";
			gwtmv = "git worktree move";
			gwtrm = "git worktree remove";
			gstu = "gsta --include-untracked";

			man-php = let php-manual-html = pkgs.stdenv.mkDerivation {
				pname = "php-manual-en-html";
				version = "8.3@26-03-2024";

				src = pkgs.fetchurl {
					url = "https://www.php.net/distributions/manual/php_manual_en.tar.gz";
					hash = "sha256-3HpLLgPYsURFk3satGyFd/4jZOKi20arhN+5vL378Io=";
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
