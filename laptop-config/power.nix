# This modules shall only setup stuff to manage battery power, hibernation ect.
{pkgs, ...}:
let
	script = with pkgs; writeShellScript "battery-profile" ''
export PATH=${power-profiles-daemon}/bin:$PATH

c=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
s=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo Unknown)

[ $c -lt 20 ] && p=$([ "$s" = Charging ] && echo balanced || echo power-saver)
[ $c -ge 20 -a $c -le 80 ] && p=$([ "$s" = Charging ] && echo performance || echo balanced)
[ $c -gt 80 ] && p=performance

[ "$(powerprofilesctl get)" != "$p" ] && powerprofilesctl set "$p"
	'';
	in
{
	boot.kernelParams = [
		"amd_iommu=off"
	];
# https://wiki.archlinux.org/title/Lenovo_ThinkPad_P16s_(AMD)_Gen_2
	powerManagement = {
		enable = true;
		powertop = {
			enable = true;
		};
		powerDownCommands = with pkgs; ''
		${systemd}/bin/systemctl stop NetworkManager.service
		${kmod}/bin/modprobe -r ath11k_pci
		'';
		powerUpCommands = with pkgs; ''
		${kmod}/bin/modprobe ath11k_pci
		${systemd}/bin/systemctl start NetworkManager.service
		'';
	};
	systemd = {
		services.power-profile = {
			description = "Battery-based power profile";
			serviceConfig.Type = "oneshot";
			serviceConfig.ExecStart = script;
		};

		paths.power-profile = {
			wantedBy = [ "multi-user.target" ];
			pathConfig.PathChanged = [
				"/sys/class/power_supply/BAT0/status"
				"/sys/class/power_supply/BAT0/capacity"
			];
			pathConfig.Unit = "power-profile.service";
		};

		timers.power-profile = {
			timerConfig.OnCalendar = "*:0/5";
			timerConfig.Persistent = true;
		};
	};
}
