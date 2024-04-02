{	
	services = let
		createService = {command, description ? "noDsc"}:
		{
			Unit.Description = description;
			Service.Type = "exec";
			Service.Environment = "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/brian/bin";
			Service.ExecStart = "/etc/profiles/per-user/brian/bin/" + command;
			Service.Restart="on-failure";
			Service.RestartSec="5s";
		};
	in {
		waybar = createService {command = "waybar"; description = "start and manager waybar";};

		hyprpaper = createService {command = "hyprpaper";};
		dunst = createService {command = "dunst";};
		steam = createService {command = "steam";};
		cycle-paper =  {
			Service.Environment = "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/brian/bin";
			Service.Type = "oneshot";
			Service.ExecStart = "/etc/profiles/per-user/brian/bin/nu /home/brian/.config/hypr/wallpaper.nu";
			Unit.Description = "Cycle through wallpapers";
		};
	};

	timers = {
		 cycle-paper.Timer.OnCalendar = "*-*-* *:*:00"; 
	};

	tmpfiles.rules = [ ];
}
