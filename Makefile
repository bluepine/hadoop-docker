SHELL:=/bin/bash
all: build-hadoop-2

build-hadoop-2:
	docker build -t local/hadoop-2 --rm=true .
	bash ./clean_up_images.sh
