.PHONY: build run shell

build:
	docker build -t performance/metric-collector-lighthouse \
		-f Dockerfile .
run:
	docker run --rm --shm-size=2g performance/metric-collector-lighthouse
	# docker run --rm --shm-size=2g --env HOST=https://douglas.de --env INFLUX_HOST=host --env INFLUX_PORT=8080 performance/metric-collector-lighthouse

shell:
	docker run -it --shm-size=2g --rm performance/metric-collector-lighthouse sh