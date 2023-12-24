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
  BUF_VERSION=1.28.1 \
  PROTOBUF_VERSION=25.1 \
  DRPC=0.0.33 \
  GRPC_GATEWAY_VERSION=2.18.1 \
  GRPC_WEB_VERSION=1.5.0 \
  YARPC_VERSION=1.71.0 \
  TWIRP_VERSION=8.1.3 \
  GRPCURL_VERSION=1.8.9 \
  GHZ_VERSION=0.117.0 \
  PROTOC_GEN_GO=1.32.0 \
  PROTOC_GEN_ENT=0.4.5 \
  PROTOC_GEN_VALIDATE=1.0.2 \
  PROTOC_GEN_GO_GRPC=1.3.0

# Dependencies
RUN \
  apt update && \
  apt install -y \
  git-core \
  unzip && \
  rm -rf /var/lib/apt/lists/*

# protoc and libraries
RUN \
  mkdir -p /tmp/protoc && \
  curl -sSL \
  "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip" \
  -o /tmp/protoc/protoc.zip && \
  cd /tmp/protoc && \
  unzip protoc.zip && \
  mv /tmp/protoc/include /usr/local/include && \
  mv /tmp/protoc/bin/protoc /usr/local/bin/protoc && \
  chmod +x /usr/local/bin/protoc && \
  rm -rf /tmp/protoc

# buf
RUN \
  curl -sSL \
  "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m).tar.gz" | tar -xvzf - -C "/usr/local" --strip-components 1

# protoc-gen-go
# https://github.com/protocolbuffers/protobuf-go/releases
RUN \
  go install google.golang.org/protobuf/cmd/protoc-gen-go@v${PROTOC_GEN_GO}

# protoc-gen-validate
# https://github.com/bufbuild/protoc-gen-validate/releases
RUN \
  go install github.com/envoyproxy/protoc-gen-validate@v${PROTOC_GEN_VALIDATE}

# protoc-gen-go-grpc
# https://github.com/grpc/grpc-go
RUN \
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v${PROTOC_GEN_GO_GRPC}

# protoc-gen-go-drpc
# https://github.com/storj/drpc
RUN \
  go install storj.io/drpc/cmd/protoc-gen-go-drpc@v${DRPC}

# protoc-gen-ent
# https://github.com/ent/contrib/tree/master/entproto/cmd/protoc-gen-ent
RUN \
  go install entgo.io/contrib/entproto/cmd/protoc-gen-ent@v${PROTOC_GEN_ENT} && \
  go install entgo.io/contrib/entproto/cmd/protoc-gen-entgrpc@v${PROTOC_GEN_ENT}

# grpcurl
# https://github.com/fullstorydev/grpcurl/releases
RUN \
  curl -sSL "https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz" -o grpcurl.tgz && \
  tar -xvzf grpcurl.tgz && \
  chmod +x grpcurl && \
  mv grpcurl /usr/local/bin/. && \
  rm LICENSE grpcurl.tgz

# ghz
# https://github.com/bojand/ghz/releases
RUN \
  curl -sSL https://github.com/bojand/ghz/releases/download/v${GHZ_VERSION}/ghz-linux-x86_64.tar.gz -o ghz.tgz && \
  tar -xvzf ghz.tgz && \
  rm LICENSE ghz.tgz && \
  chmod +x ghz* && \
  mv ghz* /usr/local/bin/.

# gRPC Gateway
# https://github.com/grpc-ecosystem/grpc-gateway/releases
RUN \
  go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@v${GRPC_GATEWAY_VERSION} && \
  go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v${GRPC_GATEWAY_VERSION}

# gRPC Web
RUN \
  curl -sSL \
  https://github.com/grpc/grpc-web/releases/download/${GRPC_WEB_VERSION}/protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 \
  -o /usr/local/bin/protoc-gen-grpc-web && \
  chmod +x /usr/local/bin/protoc-gen-grpc-web

# YARPC
# https://github.com/yarpc/yarpc-go/releases
RUN \
  git clone --depth 1 -b v${YARPC_VERSION} https://github.com/yarpc/yarpc-go.git /go/src/go.uber.org/yarpc && \
  cd /go/src/go.uber.org/yarpc && \
  go install ./encoding/protobuf/protoc-gen-yarpc-go && \
  mv /go/bin/protoc-gen-yarpc-go /usr/local/bin/ && \
  rm -rf /go/src/go.uber.org

# Twirp
# https://github.com/twitchtv/twirp/releases
RUN \
  go install github.com/twitchtv/twirp/protoc-gen-twirp@v${TWIRP_VERSION}

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
