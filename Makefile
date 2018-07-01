
all: build

build: 
	docker build -f Dockerfile -t quay.io/pjsk/http-memcached-example:v1 .

push: all
	docker push quay.io/pjsk/http-memcached-example:v1
