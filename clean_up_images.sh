#!/bin/bash
dangling_image=$(docker images -f 'dangling=true' -q); if [ -n "${dangling_image}" ]; then docker rmi ${dangling_image}; fi
