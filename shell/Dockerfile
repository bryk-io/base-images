FROM busybox:stable

ARG VERSION

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

# CA roots are extracted from `debian:stable-slim` image
COPY ca-roots.crt /etc/ssl/certs/

# Add default `guest` user 
RUN \
  adduser -h /home/guest -g "container-user" -s /bin/sh -D -u 10001 guest guest && \
  mkdir -p /usr/local/bin && \
  mkdir /var/run && \
  chown guest /var/run && \
  mkdir /opt && \
  chown guest /opt

# Set default user
ENV \
  USER=guest \
  UID=10001

USER guest:guest
