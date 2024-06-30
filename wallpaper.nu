#!env nu

def main [] {
    let W_DIR = "/home/brian/Wallpapers"
    let SIZE = (ls $W_DIR | length) - 1
    # let T_MAX = 20
    # let T_MIN = 10


	# Find monitors and select random wallpapers for each one
	let monitors = hyprctl monitors | parse "Monitor {monitor} ({id}):" | get monitor | each {|e| [ (ls ~/Wallpapers | where type == file | select (random int 0..50 )).name.0 $e ] }

	# apply each wallpaper to each monitor
    $monitors | each {|it|
        hyprctl hyprpaper preload  $"($it.0)"
        hyprctl hyprpaper wallpaper $"($it.1),($it.0)"
		hyprctl hyprpaper unload $"$($it.0)"
    }

    # Pass if mpvpaper is running
    # if ( (ps | where name =~ mpvpaper | length) > 0 ) { continue }
}
