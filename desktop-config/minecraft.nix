{pkgs, lib, ...}:
let
	modpack = pkgs.fetchModrinthModpack {
		src = ./modpack.mrpack;
		packHash = "sha256-uw0aP2xLlQHZsWggtRxomU6hFRYLG5lQAkqVGZR5U6k=";
		side = "server";
	};
in
{
	services.minecraft-servers = {
		enable = true;
		eula = true;
		openFirewall = true;

		servers.johnpork = {
			enable = true;
			autoStart = false;
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

			package = pkgs.fabricServers.fabric-1_21_11.override { loaderVersion = "0.19.5"; };
			jvmOpts = "-Xms2048M -Xmx10G";
			# symlinks = {
			# 	"mods" = "${modpack}/mods";
			# };
			# files = {
			# 	"config" = "${modpack}/config";
			# };
		};
	};
}
