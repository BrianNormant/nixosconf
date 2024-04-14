#!/run/current-system/sw/bin/zsh

if [[ -z `env playerctl --list-all` ]]; then
	exit;
fi

fn fetch() {
	playerctl metadata $1
}

title=`fetch 'title'`
artist=`fetch 'artist'`
album=`fetch 'album'`
eval `systemctl --user show-environment | grep CURRENT_PLAYER`

case $CURRENT_PLAYER in
	firefox*)
		echo -n "󱉺 "
		;;
	cmus*)
		echo -n "󰎄 "
		;;
	*)
		echo -n "󰝛 "
		;;
esac


if [[ -n $artist && -n $album ]]; then	
	#format='{ "title": "%s", "artist": "%s", "album" : "%s" }'
	format='%s by %s from %s'
	
	env printf "$format" "$title" "$artist" "$album"
	
elif [[ -n $artist && -z $album ]]; then
	#format='{ "title": "%s", "artist": "%s" }'
	format='%s by %s'

	env printf "$format" "$title" "$artist"
	
elif [[ -z $artist && -n $album ]]; then
	#format='{ "title": "%s", "album" : "%s" }'
	format='%s from %s'

	env printf "$format" "$title" "$album"
else
	print $title
fi
