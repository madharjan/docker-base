# docker-base

[![](https://images.microbadger.com/badges/image/madharjan/docker-base.svg)](http://microbadger.com/images/madharjan/docker-base "Get your own image badge on microbadger.com")

Docker baseimage based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker)

**Changes**
* Removed `ssh` service
* Added environment variables to disable services

Example:
```
docker run -d -t \
  -e DISABLE_SYSLOG=1 \
  -e DISABLE_CRON=0 \
  --name <container-name> -t <image-name>:<image-version>
```

**Environment**

| Environment    | Default | Set to disable |
|----------------|---------|----------------|
| DISABLE_SYSLOG | 0       | 1              |
| DISABLE_CRON   | 0       | 1              |

## Build

### Clone this project
```
git clone https://github.com/madharjan/docker-base
cd docker-base
```

**For Mac & Windows**
using VirtualBox & Ubuntu Cloud Image

**Install Tools**

* [VirtualBox][virtualbox] 4.3.10 or greater
* [Vagrant][vagrant] 1.6 or greater
* [Cygwin][cygwin] (if using Windows)

Install `vagrant-vbguest` plugin to auto install VirtualBox Guest Addition to virtual machine.
```
vagrant plugin install vagrant-vbguest
```

[virtualbox]: https://www.virtualbox.org/
[vagrant]: https://www.vagrantup.com/downloads.html
[cygwin]: https://cygwin.com/install.html

**Startup Ubuntu VM on VirtualBox**
```
vagrant up
vagrant ssh
```

**Change directory to Project Folder (within Ubuntu VM)**
```
cd /vagrant
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

# update Makefile & Changelog.md
# release
make release
```

**Tag and Commit to Git**
```
git tag 14.04
git push origin 14.04
```
