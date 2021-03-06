# Appdaemon Docker Image

## Description

[![Appdaemon version](https://img.shields.io/github/v/tag/2sheds/alpine-appdaemon?label=appdaemon&logo=python&logoColor=white)](https://github.com/home-assistant/appdaemon/releases)
[![Docker cloud build](https://img.shields.io/docker/cloud/build/kurapov/alpine-appdaemon?logo=docker&logoColor=white)](https://hub.docker.com/r/kurapov/alpine-appdaemon/builds)
[![Docker image pulls](https://img.shields.io/docker/pulls/kurapov/alpine-appdaemon?logo=docker&logoColor=white)](https://hub.docker.com/r/kurapov/alpine-appdaemon)

Small docker image with [Appdaemon](https://github.com/home-assistant/appdaemon) based on [Alpine Linux](https://hub.docker.com/_/alpine/).

This image should be available (unless automated build failed) for the following architectures:
 * amd64
 * armhf
 * arm64

I'm using a proper manifest so you can use the main tags ("latest" and version-based "X.X" or "X.X.X") directly (no need for amd64-X.X.X).

If you want to learn more about multi-architecture docker images, please read [this blog post](https://blog.slucas.fr/series/multi-architecture-docker-image/)

## Usage

```
docker run -d --name appdaemon -p 80:5050 kurapov/alpine-appdaemon
```

### Configuration

It's recommended to map a directory into the container to configure Appdaemon.

```
-v /var/opt/docker/appdaemon:/conf \
```

By default this container run as root but there is an embedded user with uid 1000 so you can start your image like that :

```
docker run -it --user 1000 --rm -v /var/opt/docker/appdaemon:/conf kurapov/alpine-appdaemon
```

Of course you need to have a local user with uid 1000.

## License
This project is licensed under `Apache License v2.0`.
