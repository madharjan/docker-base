# docker-base
Docker baseimage based on phusion/baseimage-docker

## Setup

1) Install dependencies

* [VirtualBox][virtualbox] 4.3.10 or greater.
* [Vagrant][vagrant] 1.6 or greater.
* [Cygwin][cygwin] if using Windows.

```
vagrant plugin install vagrant-vbguest
```

[virtualbox]: https://www.virtualbox.org/
[vagrant]: https://www.vagrantup.com/downloads.html
[cygwin]: https://cygwin.com/install.html

2) Clone this project

```
git clone https://github.com/madharjan/docker-base
cd docker-base
```

3) Startup Ubuntu VM on VirtualBox

```
vagrant up
```
