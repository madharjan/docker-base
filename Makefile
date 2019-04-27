
NAME = madharjan/docker-base
VERSION = 16.04

.PHONY: all build run tests clean tag_latest release clean_images

all: build

build:
	docker build \
	 --build-arg UBUNTU_VERSION=${VERSION} \
	 --build-arg VCS_REF=`git rev-parse --short HEAD` \
	 --build-arg DEBUG=true \
	 -t $(NAME):$(VERSION) --rm .

run:
	docker run -d \
		-e DEBUG=true \
		--name base $(NAME):$(VERSION)

	sleep 1

	docker run -d \
		-e DEBUG=true \
		-e DISABLE_SYSLOG=1 \
		--name base_no_syslog $(NAME):$(VERSION)

	sleep 1

	docker run -d \
		-e DEBUG=true \
		-e DISABLE_CRON=1 \
		--name base_no_cron $(NAME):$(VERSION)

	sleep 1

tests:
	sleep 2
	./bats/bin/bats test/tests.bats

clean:
	docker stop base base_no_syslog base_no_cron || true
	docker rm base base_no_syslog base_no_cron || true

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: run tests clean tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION) ***"
	curl -X POST https://hooks.microbadger.com/images/madharjan/docker-base/x2dDUennV51OiIhNh02THCSOLW4=

clean_images:
	docker rmi $(NAME):latest $(NAME):$(VERSION) || true
