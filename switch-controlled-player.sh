#!/run/current-system/sw/bin/zsh

typeset -A all_players=()

i=1
for p in `env playerctl -l`; do
	all_players[$i]=$p
	i=$(( i + 1 ))
done


if [[ ${#all_players} == 0 ]]; then
	systemctl --user unset-environment CURRENT_PLAYER
	echo "no player, unset"
	exit
fi

eval `systemctl --user show-environment | grep CURRENT_PLAYER`


if [[ -z $CURRENT_PLAYER ]]; then
	CURRENT_PLAYER=$all_players[1]
	echo "wrong player, choosed $CURRENT_PLAYER"
	systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
	exit;
fi

if [[ ${#all_players} == 1 ]]; then
	CURRENT_PLAYER=$all_players[1]
	systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
	exit;
fi


for i p in ${(kv)all_players}; do
	if [[ $p == $CURRENT_PLAYER ]]; then
		if [[ $i == ${#all_players} ]]; then
			CURRENT_PLAYER=$all_players[1]
			systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
			echo "Rollback $CURRENT_PLAYER"
			exit
		else
			i=$(( i + 1 ))
			CURRENT_PLAYER=$all_players[$i]
			systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
			echo "Next $CURRENT_PLAYER"
			exit
		fi
	fi
done

CURRENT_PLAYER=$all_players[0]
systemctl --user set-environment CURRENT_PLAYER=$CURRENT_PLAYER
exit;
