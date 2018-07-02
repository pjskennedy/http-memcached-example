
all: build

build: 
	docker build -f Dockerfile -t quay.io/pjsk/http-memcached-example:v1 .
	docker build -f Dockerfile.haproxy -t quay.io/pjsk/haproxy:1.8 .

push: all
	docker push quay.io/pjsk/http-memcached-example:v1
	docker push quay.io/pjsk/haproxy:1.8
