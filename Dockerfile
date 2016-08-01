FROM ubuntu:14.04
MAINTAINER Madhav Raj Maharjan <madhav.maharjan@gmail.com>

ENV HOME /root

RUN mkdir -p /build
COPY . /build

RUN chmod 750 /build/scripts/install.sh && /build/scripts/install.sh
RUN chmod 750 /build/scripts/cleanup.sh && /build/scripts/cleanup.sh

WORKDIR /root

CMD ["/sbin/my_init"]
