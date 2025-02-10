FROM golang:alpine as BUILD

WORKDIR /go/src
RUN set -x \
  \
  && apk add --no-cache \
    git \
    make \
    bash \
    rsync \
  \
  && VERSION=$(wget -O - https://api.github.com/repos/kubernetes/kubernetes/releases/latest |grep tag_name | cut -d '"' -f 4) \
  && git clone -b $VERSION https://github.com/kubernetes/kubernetes.git \
  && cd kubernetes \
  && make \
    kube-proxy

FROM alpine:edge

COPY --from=BUILD /go/src/kubernetes/_output/bin/kube-proxy /usr/local/bin/
RUN set -x \
  \
  && apk add --no-cache \
    conntrack-tools \
    nftables \
    iptables \
    ipset \
    kmod