{pkgs, lib, main-user, ...}:
{
	users = {
		users = {
			"${main-user}" = {
				extraGroups = [
					"docker"
					"kvm"
				];
				packages = with pkgs; [
					winapps
					winapps-launcher
					freerdp
				];
			};
		};
	};
	virtualisation = {
		docker = {
			enable = true;
		};
		oci-containers.backend = "docker";
		oci-containers.containers."WinApps" = {
			image = "ghcr.io/dockur/windows:latest";
			environment = {
				VERSION = "11";
				RAM_SIZE = "4G"; # RAM allocated to the Windows VM.
				CPU_CORES = "4"; # CPU cores allocated to the Windows VM.
				DISK_SIZE = "64G"; # Size of the primary hard disk.
				# DISK2_SIZE = "32G"; # Uncomment to add an additional hard disk to the Windows VM. Ensure it is mounted as a volume below.
				USERNAME = "Brian"; # Edit here to set a custom Windows username. The default is 'MyWindowsUser'.
				PASSWORD = "1234"; # Edit here to set a password for the Windows user. The default is 'MyWindowsPassword'.
				HOME = "/home/brian"; # Set path to Linux user home folder.
			};
			ports = [
				"8006:8006" # Map '8006' on Linux host to '8006' on Windows VM --> For VNC Web Interface @ http://127.0.0.1:8006.
				"3389:3389/tcp" # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
				"3389:3389/udp" # Map '3389' on Linux host to '3389' on Windows VM --> For Remote Desktop Protocol (RDP).
			];
			volumes = [
				"data:/storage" # Mount volume 'data' to use as Windows 'C:' drive.
				"/home/brian:/shared" # Mount Linux user home directory @ '\\host.lan\Data'.
				"./oem:/oem" # Enables automatic post-install execution of 'oem/install.bat', applying Windows registry modifications contained within 'oem/RDPApps.reg'.
			];
			devices = [
				"/dev/kvm" # Enable KVM.
				"/dev/net/tun" # Enable tuntap
			];
			capabilities = {
				NET_ADMIN = true;
			};
		};
	};

}
