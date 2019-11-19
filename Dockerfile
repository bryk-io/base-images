FROM alpine:3.10.3

LABEL maintainer="Ben Cessa <ben@pixative.com>"

ARG DOCKER_CLI_VERSION="17.12.1-ce"
ARG HELM_VERSION="3.0.0"
ARG KUBECTL_VERSION="1.16.0"

COPY run.sh /bin/run

# helm
RUN \
  apk add make git && \
  wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/. && \
  rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  helm plugin install https://github.com/chartmuseum/helm-push

# kubectl
RUN \
  wget https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/local/bin/. && \
  chown root:root /usr/local/bin/helm && \
  chmod +x /bin/run

# docker client
RUN \
  wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz && \
  tar xvzf docker-${DOCKER_CLI_VERSION}.tgz && \
  mv docker/* /usr/local/bin/. && \
  rm -rf docker docker-${DOCKER_CLI_VERSION}.tgz
