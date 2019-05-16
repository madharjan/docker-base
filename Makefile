
NAME = madharjan/docker-base
VERSION = 16.04

DEBUG ?= true

.PHONY: all build run tests clean tag_latest release clean_images

all: build

build:
	docker build \
	 --build-arg UBUNTU_VERSION=${VERSION} \
	 --build-arg VCS_REF=`git rev-parse --short HEAD` \
	 --build-arg DEBUG=$(DEBUG) \
	 -t $(NAME):$(VERSION) --rm .

run:
	docker run -d \
		-e DEBUG=$(DEBUG) \
		--name base $(NAME):$(VERSION) \
		/sbin/my_init --log-level 3

	sleep 1

	docker run -d \
		-e DEBUG=$(DEBUG) \
		-e DISABLE_SYSLOG=1 \
		--name base_no_syslog $(NAME):$(VERSION)

	sleep 1

	docker run -d \
		-e DEBUG=$(DEBUG) \
		-e DISABLE_CRON=1 \
		--name base_no_cron $(NAME):$(VERSION)

	sleep 1

tests:
	sleep 2
	./bats/bin/bats test/tests.bats

stop:
	docker stop base base_no_syslog base_no_cron || true

clean: stop
	docker rm base base_no_syslog base_no_cron || true
	docker images | grep "^<none>" | awk '{print$3 }' | xargs docker rmi || true

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: run tests clean tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION) ***"
	curl -s -X POST https://hooks.microbadger.com/images/madharjan/docker-base/x2dDUennV51OiIhNh02THCSOLW4=

clean_images:
	docker rmi $(NAME):latest $(NAME):$(VERSION) || true
