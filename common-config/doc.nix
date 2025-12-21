{pkgs, lib, ...}:
{
	documentation = {
		man = {
			enable = true;
			# we need to generate the cache to have acess to the manpages
			generateCaches = true;
		};
		info = { enable = true; };
		nixos = { enable = true; };
		dev = { enable = true;};
	};
}
