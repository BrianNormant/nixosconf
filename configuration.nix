{mkNixos, inputs, overlays, ...}:
let cm = [
	({hostname, ...}: { networking.hostName = hostname; })
	./common-config/bluetooth.nix
	./common-config/boot.nix
	./common-config/doc.nix
	./common-config/fonts.nix
	./common-config/gpu.nix
	./common-config/network.nix
	./common-config/nix-settings.nix
	./common-config/others.nix
	./common-config/performance.nix
	./common-config/print.nix
	./common-config/security.nix
	./common-config/services.nix
	./common-config/users.nix
	# No need for winapps as of now, rm app works wine 10.17+
	# ./common-config/winapps.nix
	./common-config/recorder.nix

	./common-config/nixvim.nix
	./common-config/zsh.nix
	inputs.nixvim.nixosModules.default
	inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
	overlays
];
in
	{
	BrianNixLaptop = mkNixos {
		user = "brian";
		hostname = "BrianNixLaptop";
		modules = cm ++ [
			./hardware-config/hardware-Laptop.nix
			./laptop-config/fingerprint.nix
			./laptop-config/ssh.nix
			((import ./server-config/chatbot-webui.nix) "http://ggkbrian:11434")
		];
	};
	BrianNixDesktop = mkNixos {
		user = "brian";
		hostname = "BrianNixDesktop";
		modules = cm ++ [
			./hardware-config/hardware-Desktop.nix
			./desktop-config/controllers.nix
			./desktop-config/gaming.nix
			./desktop-config/vr.nix
			./desktop-config/ssh.nix
			./desktop-config/firewall.nix
			((import ./server-config/chatbot-webui.nix) "http://127.0.0.1:11434")
			./server-config/ollama.nix
		];
	};
}
