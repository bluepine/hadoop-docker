#!/bin/bash
containers=$(docker ps -a -q); if [ -n "${containers}" ]; then docker rm $containers; fi
dangling_image=$(docker images -f 'dangling=true' -q); if [ -n "${dangling_image}" ]; then docker rmi ${dangling_image}; fi
