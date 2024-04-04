hostname:
{
	enable = true;
	style = ./waybar-style.css;
	settings = {
		mainBar = {
			layer = "top";
			position = "top";
			modules-left = [
				"custom/hostname"
				"cpu"
				"memory"
				"disk"
				"hyprland/workspaces"
			];
			modules-center = [
				"custom/music"
				"hyprland/window"
			];
			modules-right = [
				"custom/packages"
					"network#wifi"
					"battery"
					"backlight"
					"pulseaudio"
					"clock"
					"tray"
			];
			"custom/hostname" = { 
				exec = "hostname"; 
				format = " {}";
				tooltip = false;
			};
			"hyprland/workspaces" = {
				format = "{id}";
				show-special = true;
				on-scroll-up   = "hyprctl dispatch workspace e+1";
				on-scroll-down = "hyprctl dispatch workspace e-1";
			};
			"clock" = {
				format = " {:%H:%M}";
				tooltip-format = "\n<span size='9pt' font='WenQuanYi Zen Hei Mono'>{calendar}</span>";
				calendar = {
					mode = "year";
					mode-mon-col = 3;
					weeks-pos = "right";
					on-scroll = 1;
					on-click-right = "mode";
					format = {
						months = "<span color='#ffead3'><b>{}</b></span>";
						days = "<span color='#ecc6d9'><b>{}</b></span>";
						weeks = "<span color='#99ffdd'><b>W{}</b></span>";
						weekdays = "<span color='#ffcc66'><b>{}</b></span>";
						today = "<span color='#ff6699'><b><u>{}</u></b></span>";
					};
				};
				actions = {
					on-click-right = "mode";
					on-click-forward = "tz_up";
					on-click-backward = "tz_down";
					on-scroll-up = "shift_up";
					on-scroll-down = "shift_down";
				};
			};
			"hyprland/window" = {
				max-length = 60;
				separate-outputs = false;
			};
			"memory" = {
				interval = 5;
				format = " {}%";
			};
			"cpu" = {
				interval = 5;
				format = " {usage:2}%";
			};
			"disk" = {
				format = "  {free}/{total}";
				tooltip = false;
				path = "/";
			};
			"custom/packages" = {
				exec = "nix-store --query --requisites /run/current-system | wc -l";
				format = " {}";
				interval = 60;
			};

			"custom/music" = {
				exec = "/home/brian/.config/script/media.zsh";
				format = "󰎄 {}";
				interval = 5;
				on-click = "systemctl --user start switch-playerctl.service";
				max-length = 30;
			};
			"network#wifi" = {
				interval = 10;
				interface = if hostname == "BrianNixLaptop"
					then "wlp2s0" else "wlp15s0";
				format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
				format-wifi = "{icon} {signalStrength}%";
				format-disconnected = "󰤮";
				tooltip = false;
			};
			"tray" = { spacing = 12; };
			"pulseaudio" = {
				format = "{icon} {volume}% {format_source}";
				format-bluetooth = "{volume}% {icon} {format_source}";
				format-bluetooth-muted = " {icon} {format_source}";
				format-muted = " {format_source}";
				format-source = " {volume}%";
				format-source-muted = "";
				on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
				format-icons = {
					headphone = "";
					hands-free = "";
					headset = "";
					phone = "";
					portable = "";
					car = "";
					default = ["" "" ""];
				};
			};
			"battery" = {
				states = {
					warning = 30;
					critical = 30;
				};
				format = "{icon} {capacity}%";
				format-charging = "󱟦 {capacity}%";
				format-plugged = "󱘖 {capacity}%";
				format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
				tooltip = false;
			};
			"backlight" = { format = "{percent} 󰌵"; };
		};
	};
}
