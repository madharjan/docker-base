
NAME = madharjan/docker-base
VERSION = 14.04

.PHONY: all build run tests clean tag_latest release clean_images

all: build

build:
	docker build --build-arg UBUNTU_VERSION=${VERSION} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg DEBUG=true -t $(NAME):$(VERSION) --rm .

run:
	docker run -d -t --name base -t $(NAME):$(VERSION)
	docker run -d -t -e DISABLE_SYSLOG=1 --name base_no_syslog -t $(NAME):$(VERSION)
	docker run -d -t -e DISABLE_CRON=1 --name base_no_cron -t $(NAME):$(VERSION)

tests:
	./bats/bin/bats test/tests.bats

clean:
	docker stop base base_no_syslog base_no_cron
	docker rm base base_no_syslog base_no_cron

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: run tests clean tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION) ***"
	curl -X POST https://hooks.microbadger.com/images/madharjan/docker-base/x2dDUennV51OiIhNh02THCSOLW4=

clean_images:
		docker rmi $(NAME):latest $(NAME):$(VERSION) || true
