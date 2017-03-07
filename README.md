# docker-base

[![](https://images.microbadger.com/badges/image/madharjan/docker-base.svg)](http://microbadger.com/images/madharjan/docker-base "Get your own image badge on microbadger.com")

Docker baseimage based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker)

**Changes**
* Removed `ssh` service

**Features**
* Environment variables to disable services
* Using scripts in `my_init.d` to initialize services (e.g base-startup.sh, nginx-startup.sh .. etc)
* Using scripts in `my_shutdown.d` to cleanup services before container stop (e.g postfix-stop.sh ..etc)
* Bats ([sstephenson/bats](https://github.com/sstephenson/bats/)) based test cases

Example:
```
docker run -d \
  -e DISABLE_SYSLOG=1 \
  -e DISABLE_CRON=0 \
  --name <container-name> <image-name>:<image-version>
```

## Ubuntu 14.04 (docker-base)

**Environment**

| Variable       | Default | Set to disable |
|----------------|---------|----------------|
| DISABLE_SYSLOG | 0       | 1              |
| DISABLE_CRON   | 0       | 1              |

## Build

### Clone this project
```
git clone https://github.com/madharjan/docker-base
cd docker-base
```

### Build Container `baseimage`
```
# login to DockerHub
docker login

# build
make

# tests
make run
make tests
make clean

# tag
make tag_latest

# update Changelog.md
# release
make release
```

**Tag and Commit to Git**
```
git tag 14.04
git push origin 14.04
```
