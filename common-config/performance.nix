{pkgs, lib, main-user, ...}:
{
	services = {
		lact.enable = true;
	};
	hardware.amdgpu.overdrive.enable = true;
}
