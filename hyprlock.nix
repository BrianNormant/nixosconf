monitor: ''
general {
	no_fade_in = false
	grace = 0
	disable_loading_bar = false
}
background {
	monitor = ${monitor}
	path = ~/Wallpapers/lockscreen.jpg
	blur_passes = 3
} 
'' + ( if monitor == "DP-1" then ''
background {
	monitor = HDMI-A-1
	path = ~/Wallpapers/gunlockscreen.jpg
	blur_passes = 3
}
background {
	monitor = DP-2
	path = ~/Wallpapers/916lockscreen.jpg
	blur_passes = 3
} 
'' else "" ) + ''

input-field {
	monitor = ${monitor}
	size = 250, 60
	outline_thickness = 2
	dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
	dots_spacing = 0.2 # Scale of dots' absolute size, 0.0 - 1.0
	dots_center = true
	outer_color = rgba(0, 0, 0, 0)
	inner_color = rgba(0, 0, 0, 0.5)
	font_color = rgb(200, 200, 200)
	fade_on_empty = false
	font_family = JetBrains Mono Nerd Font Mono
	placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
	hide_input = false
	position = 0, -120
	halign = center
	valign = center
}

# TIME
label {
	monitor = ${monitor}
	text = cmd[update:1000] echo "$(date +"%-I:%M%p")"
	color = $foreground
#color = rgba(255, 255, 255, 0.6)
	font_size = 120
	font_family = JetBrains Mono Nerd Font Mono ExtraBold
	position = 0, -300
	halign = center
	valign = top
}
''
