FROM debian:buster
LABEL maintainer "Koichi Nakashima <koichi@nksm.name>"

ENV VERSION=0.1.0 DEBCONF_NOWARNINGS=yes LANG=C.UTF-8
RUN apt-get update && apt-get install -y --no-install-recommends \
      zulucrypt-cli zulumount-cli unionfs-fuse openvpn easy-rsa openssl \
      openssh-client p7zip-full zip unzip libpwquality-tools cracklib-runtime \
      curl wget vim less tree procps man

WORKDIR /root
COPY docker/. /
RUN if [ -f .onbuild ]; then sh .onbuild; fi
