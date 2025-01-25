FROM golang:alpine as BUILD
ARG VERSION=1.32.1

WORKDIR /go/src
RUN set -x \
  \
  && apk add --no-cache \
    git \
    make \
    bash \
    rsync \
  \
  && git clone -b v$VERSION https://github.com/kubernetes/kubernetes.git \
  && cd kubernetes \
  && make \
    kube-proxy

FROM alpine:edge

COPY --from=BUILD /go/src/kubernetes/_output/bin/ /usr/local/bin
RUN set -x \
  \
  && apk add --no-cache \
    conntrack-tools \
    nftables \
    iptables \
    ipset \
    kmod