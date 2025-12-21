{pkgs, ...}: {
	services.gpu-screen-recorder = {
		enable = true;
		package = pkgs.gpu-screen-recorder;
	};
	environment.systemPackages = with pkgs; [
		gpu-screen-recorder
		gpu-screen-recorder-gtk
	];
}
