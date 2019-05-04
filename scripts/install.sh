#!/bin/bash
set -e
export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

if [ "${DEBUG}" = true ]; then
  set -x
fi

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
	echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list

apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

## Install HTTPS support for APT.
## Install add-apt-repository
## Fix locale.

apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  language-pack-en \
  software-properties-common \
  apt-utils

locale-gen en_US
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
mkdir -p /etc/container_environment
echo -n en_US.UTF-8 > /etc/container_environment/LANG
echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE

## Install init process.
cp /build/bin/my_init /sbin/
chmod 750 /sbin/my_init

touch /etc/container_environment.sh
touch /etc/container_environment.json
chmod 700 /etc/container_environment

groupadd -g 8377 docker_env
chown :docker_env /etc/container_environment.sh /etc/container_environment.json
chmod 640 /etc/container_environment.sh /etc/container_environment.json
ln -s /etc/container_environment.sh /etc/profile.d/

mkdir -p /etc/my_init.d
mkdir -p /etc/my_shutdown.d

## Install runit.
apt-get install -y --no-install-recommends runit

## Install a syslog daemon and logrotate.
/build/services/syslog-ng/syslog-ng.sh

## Install cron daemon.
/build/services/cron/cron.sh

## Often used tools.
apt-get install -y --no-install-recommends \
  curl \
  less \
  nano \
  psmisc \
  wget

## This tool runs a command as another user and sets $HOME.
cp /build/bin/setuser /sbin/setuser
chmod 750 /sbin/setuser

cp /build/services/10-startup.sh /etc/my_init.d
cp /build/services/90-shutdown.sh /etc/my_shutdown.d

chmod 750 /etc/my_init.d/10-startup.sh
chmod 750 /etc/my_shutdown.d/90-shutdown.sh
