###############################################################################
#
# This Dockerfile should only be used to cross-compile Packagr for various
# OS's and Architectures. Its massive, and should not be used as a base image
# for your Dockerfiles.
#
# Usable Docker Images and Dockerfiles for different languages are located:
# - https://github.com/Packagrio/docker-packagr
# - https://github.com/PackagrIO/docker-packagr/pkgs/container/packagr
#
# Use `docker pull ghcr.io/packagrio/packagr:latest-<language>`
#
###############################################################################
FROM ghcr.io/packagrio/libgit2-xgo:master
MAINTAINER Jason Kulatunga <jason@thesparktree.com>

WORKDIR /go/src/github.com/analogj/packagr

ENV PATH="/go/src/github.com/packagrio/packagr:/go/bin:${PATH}" \
	SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Install build tooling.
RUN echo "go version: \
    && go version \
    && apt-get update \
	&& apt-get install -y gcc git build-essential binutils curl apt-transport-https ca-certificates pkg-config --no-install-recommends \
	&& rm -rf /usr/share/doc && rm -rf /usr/share/man \
	&& rm -rf /var/lib/apt/lists/* \
    && apt-get clean


ENV PATH="/go/bin:/usr/local/go/bin:${PATH}" \
	GOPATH="/go:${GOPATH}" \
	SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# ensure go is configured correctly
RUN which go \
    && mkdir -p /go/bin \
    && mkdir -p /go/src \
    && go get -u gopkg.in/alecthomas/gometalinter.v2 \
    && gometalinter.v2 --install

COPY ./packagr.sh /scripts/packagr.sh

RUN /scripts/packagr.sh
