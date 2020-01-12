FROM debian:buster
LABEL maintainer "Koichi Nakashima <koichi@nksm.name>"

ENV DEBCONF_NOWARNINGS=yes LANG=C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
      zulucrypt-cli zulumount-cli unionfs-fuse ntfs-3g openvpn easy-rsa \
      openssl p7zip-full zip unzip libpwquality-tools cracklib-runtime \
      openssh-client curl wget vim less tree procps man

ENV VERSION=0.1.0 DATADIR=/var/data
WORKDIR /root
COPY docker/. /
RUN if [ -f .onbuild ]; then sh .onbuild; fi
