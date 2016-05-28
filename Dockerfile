FROM ubuntu:trusty

MAINTAINER Hari Jiang <hari.jiang@outlook.com>

ENV DEPENDENCIES git-core build-essential autoconf libtool libssl-dev polipo
ENV BASEDIR /tmp/shadowsocks-libev
ENV PORT 8338
ENV HTTP_PROXY_PORT 8000
ENV VERSION v2.4.1

# Set up building environment
RUN apt-get update \
 && apt-get install -y $DEPENDENCIES

# Get the latest code, build and install
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git $BASEDIR
WORKDIR $BASEDIR
RUN git checkout $VERSION \
 && ./configure \
 && make \
 && make install

# Tear down building environment and delete git repository
WORKDIR /
RUN rm -rf $BASEDIR/shadowsocks-libev\
 && apt-get --purge autoremove -y $DEPENDENCIES

EXPOSE $PORT
EXPOSE $HTTP_PROXY_PORT

# Override the host and port in the config file.
ADD entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["-h"]
