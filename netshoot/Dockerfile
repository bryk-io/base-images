FROM alpine:3.23

ARG VERSION

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

# CA roots are extracted from `debian:stable-slim` image
COPY ca-roots.crt /etc/ssl/certs/

# Add default `guest` user 
RUN \
  apk add btop bind-tools iftop iperf iproute2-ss nload nethogs tcpdump wireshark && \
  addgroup -g 10001 -S k8-guest && \
  adduser -h /home/k8-guest -s /bin/sh -u 10001 -D -G k8-guest k8-guest && \
  addgroup k8-guest wireshark

# Set default user
ENV \
  USER=k8-guest \
  UID=10001 \
  LANG=en_US.UTF-8

WORKDIR /home/k8-guest

USER k8-guest:k8-guest
