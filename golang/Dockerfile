FROM golang:1.14-buster

ARG VERSION
ARG HELM_VERSION="3.2.4"
ARG GOLANGCI_VERSION="1.28.0"

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

ENV \
  USER=guest \
  UID=10001 \
  HOME=/home/guest

RUN \
  adduser \
  --home ${HOME} \
  --gecos "container-user" \
  --disabled-password \
  --shell /bin/sh \
  --uid 10001 ${USER}

RUN \
  # Setup git and SSH installation
  echo "   IdentityFile /drone/src/key" >> /etc/ssh/ssh_config && \
  mkdir -p -m 0750 ${HOME}/.ssh && \
  git config --system url."ssh://git@github.com:".insteadOf "https://github.com" && \
  git config --system url."ssh://git@bitbucket.org:".insteadOf "https://bitbucket.org" && \
  ssh-keyscan -t rsa github.com >> ${HOME}/.ssh/known_hosts && \
  ssh-keyscan -t rsa bitbucket.org >> ${HOME}/.ssh/known_hosts && \
  chown -Rv ${USER}:${USER} ${HOME} && \
  # Install Helm
  cd /usr/local/bin && \
  wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  tar xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
  mv linux-amd64/helm . && \
  # Install golangci-lint
  wget https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}-linux-amd64.tar.gz && \
  tar xvzf golangci-lint-${GOLANGCI_VERSION}-linux-amd64.tar.gz && \
  mv golangci-lint-${GOLANGCI_VERSION}-linux-amd64/golangci-lint . && \
  # Cleanup
  rm -rf *.tar.gz *linux-amd64*

USER ${USER}:${USER}
