
NAME = madharjan/docker-base
VERSION = 14.04

.PHONY: all build run tests clean tag_latest release clean_images

all: build

build:
	docker build --build-arg UBUNTU_VERSION=${VERSION} --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg DEBUG=true -t $(NAME):$(VERSION) --rm .

run:
	docker run -d -t --name base -t $(NAME):$(VERSION)

tests:
	./bats/bin/bats test/tests.bats

clean:
	docker stop base
	docker rm base

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
