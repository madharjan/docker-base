FROM ubuntu:14.04
MAINTAINER Madhav Raj Maharjan <madhav.maharjan@gmail.com>

LABEL description="Docker baseimage"
LABEL  os_version="Ubuntu 14.04"

ENV HOME /root

RUN mkdir -p /build
COPY . /build

RUN /build/scripts/install.sh
RUN /build/scripts/cleanup.sh

WORKDIR /root

CMD ["/sbin/my_init"]
