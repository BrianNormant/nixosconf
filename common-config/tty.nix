{pkgs, lib, ...}:
{
	services = {
		kmscon = {
			enable = true;
			fonts = [
				{ name = "Fira Code"; package = pkgs.fira-code;}
			];
			hwRender = true;
		};
	};
}
