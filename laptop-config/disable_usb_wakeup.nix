{ pkgs, ...}: {
	systemd.services.disable-wakeup-sources = {
		description = "Disable ACPI wakeup sources that cause annoyance on AC/Battery events";
		after = [ "multi-user.target" ];
		serviceConfig = {
			Type = "oneshot";
			ExecStart = let
				devices = [
				"NHI0" "NHI1"      # Thunderbolt / USB4
				"XHC0" "XHC1" "XHC3" "XHC4"  # USB Controllers
				"GPP5" "GPP6" "GP12"         # PCIe / Bluetooth / Wi-Fi bridges
				];
			script = pkgs.writeShellScript "disable-wakeup" ''
				for device in ${builtins.concatStringsSep " " devices}; do
					if grep -q "$device.*enabled" /proc/acpi/wakeup; then
						echo "$device" > /proc/acpi/wakeup
							echo "Disabled wakeup for: $device"
							fi
							done
							'';
			in "${script}";
			RemainAfterExit = "yes";
		};
		wantedBy = [ "multi-user.target" ];
	};
}
