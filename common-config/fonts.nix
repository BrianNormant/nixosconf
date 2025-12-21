{pkgs, lib, ...}:
{
	fonts = {
		packages = with pkgs; [
			fira-code
			victor-mono
			nerd-fonts.fira-code
			mplus-outline-fonts.githubRelease
			cedarville-cursive
			flog-symbols
		];
	};
}
