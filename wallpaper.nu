#!env nu

def main [] {
    let W_DIR = "~/Wallpapers"
    let SIZE = (ls $W_DIR | length) - 1
    # let T_MAX = 20
    # let T_MIN = 10

    # Find monitors
    mut monitors = hyprctl monitors | lines | where ($it =~ 'Monitor') | parse "Monitor {monitor} (ID {ID}):" | select monitor | insert wallpaper "FILE"

    # Update to new wallpapers
    let monitors = $monitors | update wallpaper (ls $W_DIR | where type == file | select (random int 0..$SIZE)).name.0

    $monitors | each {|it|
        hyprctl hyprpaper preload  $"($it.wallpaper)"
        hyprctl hyprpaper wallpaper $"($it.monitor),($it.wallpaper)"
    }

    # Pass if mpvpaper is running
    # if ( (ps | where name =~ mpvpaper | length) > 0 ) { continue }
}
