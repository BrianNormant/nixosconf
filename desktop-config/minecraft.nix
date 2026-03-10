{pkgs, ...}:
{
	services.minecraft-server = {
		enable = true;
		package = pkgs.minecraftServers.vanilla-1-21;
		eula = true;
		declarative = true;
		openFirewall = true;
		whitelist = {
			GAKBrian = "fee68ca5-146e-42d8-bad2-b54535db21e9";
			maoSolenn = "91f928e3-4d8f-4fe6-9f5b-68d9cd40bc9c";
		};
		serverProperties = {
			server-port = 43000;
			difficulty = 1;
			gamemode = 0;
			max-players = 5;
			motd = "Le serveur officiel de John Pork";
			white-list = true;
		};
		jvmOpts = "-Xms2048M -Xmx10G";
	};
}
