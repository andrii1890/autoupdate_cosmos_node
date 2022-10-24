#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
BLOCK=269765
PALOMA_VERSION=0.11.1
PIGEON_VERSION=0.11.0
echo -e "$GREEN_COLOR NODE WILL BE UPDATED PALOMA AND PIGOEN TO VERSION: $PALOMA_VERSION $PIGEON_VERSION ON BLOCK NUMBER: $BLOCK $NO_COLOR\n"
for((;;)); do
	height=$(palomad status |& jq -r ."SyncInfo"."latest_block_height")
	if ((height>=$BLOCK)); then

		systemctl stop palomad.service pigeon.service
		mv /home/paloma/update/palomad pigeon /usr/local/bin/
		echo "restart the node..."
		systemctl restart palomad.service pigeon.service

		for (( timer=60; timer>0; timer-- )); do
			printf "* second restart after sleep for ${RED_COLOR}%02d${NO_COLOR} sec\r" $timer
			sleep 1
		done
		height=$(palomad status |& jq -r ."SyncInfo"."latest_block_height")
		if ((height>$BLOCK)); then
			echo -e "$GREEN_COLOR YOUR NODE WAS SUCCESFULLY UPDATED TO VERSION: $PALOMA_VERSION $PIGEON_VERSION $NO_COLOR\n"
		fi
		palomad version --long | head
    pigeon version --long | head
		break
	else
		echo -e "${GREEN_COLOR}$height${NO_COLOR} ($(( BLOCK - height  )) blocks left)"
	fi
	sleep 5
done
