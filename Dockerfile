ARG ALPINE_VER="3.10"
ARG PYTHON_VER="3.7"
ARG BASEIMAGE_ARCH="amd64"

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

RUN apk add --update-cache curl iputils tini ${PACKAGES} && \
    apk add --virtual=build-dependencies build-base libffi-dev ${DEPS} && \
    addgroup -g ${GUID} appdaemon && \
    adduser -D -G appdaemon -s /bin/sh -u ${UID} appdaemon && \
    pip3 install --upgrade pip && \
    egrep -e "${PLUGINS}" /tmp/requirements.txt > /tmp/requirements_plugins.txt && \
    egrep -v -e "${PLUGINS}" /tmp/requirements.txt > /tmp/requirements_wheels.txt && \
	#pip3 install --no-cache-dir --no-index --only-binary=:all: --find-links ${WHEELS_LINKS} -r /tmp/requirements_wheels.txt && \
    pip3 install --no-cache-dir --prefer-binary -r /tmp/requirements.txt appdaemon=="${VERSION}" && \
    apk del build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

ENTRYPOINT ["/sbin/tini", "--"]
EXPOSE 5050 

CMD [ "appdaemon", "-c", "/conf" ]

