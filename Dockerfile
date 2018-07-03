FROM ubuntu:16.04
LABEL maintainer="Loy B. <lonord.b@gmail.com>"
ENV NODE_VERSION 8.11.2
RUN apt-get update \
	&& apt-get install -y --no-install-recommends wget xz-utils gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake libmbedtls-dev libsodium-dev iptables ipset dnsmasq \
	&& ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
      amd64) ARCH='x64';; \
      ppc64el) ARCH='ppc64le';; \
      s390x) ARCH='s390x';; \
      arm64) ARCH='arm64';; \
      armhf) ARCH='armv7l';; \
      i386) ARCH='x86';; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac \
	&& echo "Download node v$NODE_VERSION $ARCH" \
	&& wget -q --no-check-certificate "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
	&& tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
	&& rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
	&& echo "@lonord:registry=https://registry.lonord.name/" >> /root/.npmrc \
	&& npm i -g @lonord/ss-redir-service@0.3.1 --unsafe-perm=true --allow-root \
	&& apt-get purge -y --auto-remove wget xz-utils gettext build-essential autoconf libtool asciidoc xmlto libc-ares-dev automake -y \
	&& rm -rf /var/lib/apt/lists/*
CMD [ "ss-redir-service", "-v" ]