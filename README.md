# Appdaemon Docker Image

## Description

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

It's recommended to map a directory into the container to configure home assistant.

```
-v /var/opt/docker/appdaemon:/conf \
```

By default this container run as root but there is an embedded user with uid 1000 so you can start your image like that :

```
docker run -it --user 1000 --rm -v /var/opt/docker/appdaemon:/conf kurapov/alpine-appdaemon
```

Of course you need to have a local user with uid 1000.

### Plugins

Please check the [Dockerfile template](Dockerfile.template) for the list on dependencies embedded. Any other will be downloaded automatically by Home Assistant.

## License
This project is licensed under `Apache License v2.0`.
