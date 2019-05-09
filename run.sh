#!/bin/bash

VOLUMES=/home/macc/cobbler
COBBLER_ROOT_PASS=$(cat /home/macc/.cobblerrootpass)
NEXT_SERVER=10.202.2.27
HOST_ADDRESS=c807-904.bob.macc.fct.pt 

docker run --restart unless-stopped -itd --name cobbler --network host \
    -v "$VOLUMES"/volumes/cobbler-config:/etc/cobbler \
    -v "$VOLUMES"/volumes/cobbler-data:/var/lib/cobbler \
    -v "$VOLUMES"/volumes/cobbler-tftp:/tftpboot \
    -v "$VOLUMES"/volumes/cobbler-www:/var/www/cobbler \
    -v "$VOLUMES"/volumes/cobbler-shared:/shared \
    -e DEFAULT_ROOT_PASSWD="$COBBLER_ROOT_PASS$ \
    -e NEXT_SERVER=10.202.2.27 \
    -e HOST_ADDRESS="$HOST_ADDRESS" \
    cobbler
