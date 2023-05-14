#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
NO_COLOR='\033[0m'
BLOCK=1765026
PALOMA_VERSION=v1.0.0-beta2
PIGEON_VERSION=v1.0.0-beta1
PASWD=Vjkb,ltY
echo -e "$GREEN_COLOR NODE WILL BE UPDATED PALOMA AND PIGOEN TO VERSION: $PALOMA_VERSION $PIGEON_VERSION ON BLOCK NUMBER: $BLOCK $NO_COLOR\n"
for((;;)); do
        height=$(palomad status |& jq -r ."SyncInfo"."latest_block_height")
        if ((height>=$BLOCK)); then

                echo $PASWD | sudo -S systemctl stop palomad.service pigeond.service
                sleep 5
                echo $PASWD | sudo -S mv /home/paloma/update/palomad pigeon /usr/local/bin/
                echo "restart the node..."
                echo $PASWD | sudo -S systemctl restart palomad.service pigeond.service

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
