#!/bin/bash
bash ./stop.sh
#sudo rm -rf ./shared/log
make
mkdir -p ./shared/log
#docker-compose up
docker stack deploy --compose-file=docker-compose.yml hadoop
