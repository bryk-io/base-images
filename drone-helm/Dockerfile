FROM alpine:3.12

ARG VERSION
ARG HELM_VERSION="3.2.4"

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

ENV \
  USER=drone \
  UID=10001 \
  HOME=/home/drone

RUN \
  adduser -h ${HOME} -g "container-user" -D -s /bin/sh -u 10001 ${USER}

RUN \
  # Install Helm
  cd /usr/local/bin && \
  wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm . && \
  # Cleanup
  rm -rf *.tar.gz *linux-amd64*

USER ${USER}:${USER}

ADD run.sh /usr/local/bin/deploy

CMD ["/usr/local/bin/deploy"]
