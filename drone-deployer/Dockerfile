FROM alpine:3.12

ARG VERSION
ARG DOCKER_CLI_VERSION="19.03.8"
ARG HELM_VERSION="3.2.4"
ARG KUBECTL_VERSION="1.18.5"

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

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
  mv kubectl /usr/local/bin/.

# docker client
RUN \
  wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz && \
  tar xvzf docker-${DOCKER_CLI_VERSION}.tgz && \
  mv docker/* /usr/local/bin/. && \
  rm -rf docker docker-${DOCKER_CLI_VERSION}.tgz

# add run script as default execution
COPY run.sh /bin/run
RUN chmod +x /bin/run
ENTRYPOINT ["/bin/run"]