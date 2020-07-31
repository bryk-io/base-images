FROM golang:1.14.5

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
  PROTOBUF_VERSION=3.12.3 \
  BUF_VERSION=0.20.2 \
  GRPC_GATEWAY_VERSION=1.14.6 \
  GRPC_WEB_VERSION=1.0.7 \
  YARPC_VERSION=1.45.0 \
  TWIRP_VERSION=5.10.2 \
  GRPCURL_VERSION=1.6.0 \
  GHZ_VERSION=0.55.0

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

# Base plugins and tools.
# protoc-gen-go
# protoc-gen-go-grpc
# protoc-gen-govalidators
RUN \
  go get google.golang.org/protobuf/cmd/protoc-gen-go && \
  go get google.golang.org/grpc/cmd/protoc-gen-go-grpc && \
  go get github.com/mwitkow/go-proto-validators/protoc-gen-govalidators

## grpcurl
RUN \
  curl -sSL "https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_x86_64.tar.gz" -o grpcurl.tgz && \
  tar -xvzf grpcurl.tgz && \
  chmod +x grpcurl && \
  mv grpcurl /usr/local/bin/. && \
  rm LICENSE grpcurl.tgz

# ghz
RUN \
  curl -sSL https://github.com/bojand/ghz/releases/download/v${GHZ_VERSION}/ghz-linux-x86_64.tar.gz -o ghz.tgz && \
  tar -xvzf ghz.tgz && \
  rm LICENSE ghz.tgz && \
  chmod +x ghz* && \
  mv ghz* /usr/local/bin/.

# gRPC Gateway
RUN \
  curl -sSL \
  https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v${GRPC_GATEWAY_VERSION}/protoc-gen-grpc-gateway-v${GRPC_GATEWAY_VERSION}-linux-x86_64 \
  -o /usr/local/bin/protoc-gen-grpc-gateway && \
  curl -sSL \
  https://github.com/grpc-ecosystem/grpc-gateway/releases/download/v${GRPC_GATEWAY_VERSION}/protoc-gen-swagger-v${GRPC_GATEWAY_VERSION}-linux-x86_64 \
  -o /usr/local/bin/protoc-gen-swagger && \
  chmod +x /usr/local/bin/protoc-gen-grpc-gateway && \
  chmod +x /usr/local/bin/protoc-gen-swagger

# gRPC Web
RUN \
  curl -sSL \
  https://github.com/grpc/grpc-web/releases/download/${GRPC_WEB_VERSION}/protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 \
  -o /usr/local/bin/protoc-gen-grpc-web && \
  chmod +x /usr/local/bin/protoc-gen-grpc-web

# YARPC
RUN \
  git clone --depth 1 -b v${YARPC_VERSION} https://github.com/yarpc/yarpc-go.git /go/src/go.uber.org/yarpc && \
  cd /go/src/go.uber.org/yarpc && \
  GO111MODULE=on go install ./encoding/protobuf/protoc-gen-yarpc-go && \
  mv /go/bin/protoc-gen-yarpc-go /usr/local/bin/ && \
  rm -rf /go/src/go.uber.org

# Twirp
RUN \
  git clone --depth 1 -b v${TWIRP_VERSION} https://github.com/twitchtv/twirp.git /go/src/github.com/twitchtv/twirp && \
  cd /go/src/github.com/twitchtv/twirp && \
  go install ./protoc-gen-twirp ./protoc-gen-twirp_python && \
  mv /go/bin/protoc-gen-twirp* /usr/local/bin/ && \
  rm -rf /go/src/github.com/twitchtv

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
