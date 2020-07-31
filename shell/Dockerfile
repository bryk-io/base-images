FROM busybox:1.32

ARG VERSION

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

COPY ca-roots.crt /etc/ssl/certs/

ENV \
  USER=guest \
  UID=10001

RUN \
  adduser -h /home/${USER} -g "container-user" -s /bin/sh -D -u 10001 ${USER} ${USER} && \
  mkdir -p /usr/local/bin

USER guest:guest
