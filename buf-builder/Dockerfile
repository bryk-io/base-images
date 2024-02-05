FROM golang:1.21

# Optional tools required to autogenerate RPC client and server
# implementations for different languages. Example:
# docker build --build-arg WITH_PYTHON=true ...
#
# Include Python
ARG WITH_PYTHON
# Include PHP
ARG WITH_PHP
# Include Ruby
ARG WITH_RUBY
# Include Typescript
ARG WITH_TYPESCRIPT
# Version
ARG VERSION

LABEL maintainer="Ben Cessa <ben@pixative.com>"
LABEL version=${VERSION}

ENV \
  BUF_VERSION=1.29.0 \
  DRPC=0.0.33 \
  PROTOC_GEN_ENT=0.4.5

# Dependencies
RUN \
  apt update && \
  apt install -y \
  git-core \
  unzip && \
  rm -rf /var/lib/apt/lists/*

# buf
RUN \
  curl -sSL \
  "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m).tar.gz" | tar -xvzf - -C "/usr/local" --strip-components 1

# protoc-gen-go-drpc
# https://github.com/storj/drpc
RUN \
  go install storj.io/drpc/cmd/protoc-gen-go-drpc@v${DRPC}

# protoc-gen-ent
# https://github.com/ent/contrib/tree/master/entproto/cmd/protoc-gen-ent
RUN \
  go install entgo.io/contrib/entproto/cmd/protoc-gen-ent@v${PROTOC_GEN_ENT} && \
  go install entgo.io/contrib/entproto/cmd/protoc-gen-entgrpc@v${PROTOC_GEN_ENT}

# gRPC Python tools
RUN \
  if [ -n "${WITH_PYTHON}" ]; then \
  apt update && \
  apt install -y python3-dev python3-pip && \
  pip3 install grpcio grpcio-tools && \
  rm -rf /var/lib/apt/lists/* \
  ;fi

# gRPC PHP tools
RUN \
  if [ -n "${WITH_PHP}" ]; then \
  apt update && \
  apt install -y php7.3 php7.3-dev php-pear phpunit libz-dev && \
  pecl install protobuf grpc && \
  git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc && \
  cd grpc && \
  git submodule update --init && \
  make grpc_php_plugin && \
  mv bins/opt/grpc_php_plugin /usr/local/bin/grpc_php_plugin && \
  chmod +x /usr/local/bin/grpc_php_plugin && \
  cd .. && \
  rm -rf grpc && \
  rm -rf /var/lib/apt/lists/* \
  ;fi

# gRPC Ruby tools
RUN \
  if [ -n "${WITH_RUBY}" ]; then \
  apt update && \
  apt install -y ruby-dev && \
  gem install grpc grpc-tools && \
  rm -rf /var/lib/apt/lists/* \
  ;fi

# Typescript
# https://github.com/improbable-eng/ts-protoc-gen
RUN \
  if [ -n "${WITH_TYPESCRIPT}" ]; then \
  apt update && \
  apt install -y nodejs npm && \
  npm install -g ts-protoc-gen && \
  rm -rf /var/lib/apt/lists/* \
  ;fi

# Set base working directory
WORKDIR /workdir
