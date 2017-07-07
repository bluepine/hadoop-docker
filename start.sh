#!/bin/bash
. setup.sh
bash ./stop.sh
#docker-compose up
docker stack deploy --compose-file=docker-compose.yml hadoop
