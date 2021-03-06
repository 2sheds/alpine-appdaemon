ARG ALPINE_VER="3.10"
ARG PYTHON_VER="3.7"
ARG BASEIMAGE_ARCH="amd64"
ARG DOCKER_ARCH="amd64"

FROM kurapov/alpine-jemalloc:latest-${DOCKER_ARCH} AS jemalloc

FROM ${BASEIMAGE_ARCH}/python:${PYTHON_VER}-alpine${ALPINE_VER}

ARG ALPINE_VER
ARG PKG_ARCH
ARG QEMU_ARCH

ARG BRANCH="none"
ARG COMMIT="local-build"
ARG BUILD_DATE="1970-01-01T00:00:00Z"
ARG NAME="kurapov/alpine-appdaemon"
ARG VCS_URL="https://github.com/2sheds/alpine-appdaemon"

ARG UID=1000
ARG GUID=1000
ARG MAKEFLAGS=-j4
ARG VERSION="4.0.3"
ARG JEMALLOC_VER="5.2.1"
ARG DEPS=""
ARG PACKAGES#="py3-multidict py3-idna-ssl py3-async-timeout"
ARG PLUGINS="daemonize|feedparser|deepdiff|pid|aiohttp_jinja2|yarl|Jinja2|pyyaml|bcrypt"

ENV WHEELS_LINKS="https://wheels.home-assistant.io/alpine-${ALPINE_VER}/${PKG_ARCH}/"

LABEL \
  org.opencontainers.image.authors="Oleg Kurapov <oleg@kurapov.com>" \
  org.opencontainers.image.title="${NAME}" \
  org.opencontainers.image.created="${BUILD_DATE}" \
  org.opencontainers.image.revision="${COMMIT}" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.source="${VCS_URL}"

#__CROSS_COPY qemu-${QEMU_ARCH}-static /usr/bin/

ADD "https://raw.githubusercontent.com/home-assistant/appdaemon/${VERSION}/requirements.txt" /tmp

RUN apk add --update-cache curl iputils ${PACKAGES} && \
    apk add --virtual=build-dependencies build-base libffi-dev ${DEPS} && \
    addgroup -g ${GUID} appdaemon && \
    adduser -D -G appdaemon -s /bin/sh -u ${UID} appdaemon && \
    pip3 install --upgrade pip && \
    pip3 install --no-cache-dir --prefer-binary --find-links ${WHEELS_LINKS} -r /tmp/requirements.txt appdaemon=="${VERSION}" && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

COPY --from=jemalloc /usr/local/lib/libjemalloc.so* /usr/local/lib/

ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so.2

EXPOSE 5050 

CMD [ "appdaemon", "-c", "/conf" ]

