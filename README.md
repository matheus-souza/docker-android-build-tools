# Docker Android Build Tools

[![build](https://img.shields.io/github/workflow/status/matheus-souza/docker-android-build-tools/Publish%20Docker%20image%20on%20Docker%20Hub)](https://github.com/matheus-souza/docker-android-build-tools/actions)
[![Docker Image CI](https://github.com/matheus-souza/docker-android-build-tools/actions/workflows/publish-image-dockerhub.yml/badge.svg)](https://hub.docker.com/r/matheussouza/docker-android-build-tools)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/d6a41afc8de34494b075ce42b6be8f19)](https://www.codacy.com/gh/matheus-souza/docker-android-build-tools/dashboard?utm_source=github.com&utm_medium=referral&utm_content=matheus-souza/docker-android-build-tools&utm_campaign=Badge_Grade)
[![Docker Image Size](https://badgen.net/docker/size/matheussouza/docker-android-build-tools?icon=docker&label=image%20size)](https://hub.docker.com/r/matheussouza/docker-android-build-tools)

## Introduction

An optimized **Docker** image that includes the **Android SDK**.

## What Is Inside

It includes the following components:

-   Debian 11
-   Java (OpenJDK)
    -   11
-   Android SDKs for platforms:
    -   33
-   Android build tools:
    -   33.0.0
-   cmake
-   Python (2.7.18)
-   Ruby (2.7.4), RubyGems (3.2.5)
-   fastlane (2.211.0)
-   jenv

## Pull Docker Image

The docker image is a publicly automated build on [Docker Hub](https://hub.docker.com/r/matheussouza/docker-android-build-tools)
based on the `Dockerfile` in this repo, so there is no hidden stuff in it. To pull the latest docker image:

```sh
docker pull matheussouza/docker-android-build-tools
```

**Hint:** You can use a tag to a specific stable version,
rather than `latest` of docker image, to avoid breaking your build.
e.g. `matheussouza/docker-android-build-tools:v1.0.0`.
Take a look at the [**Releases**](https://github.com/matheus-souza/docker-android-build-tools/releases) section, to see all the available releases.

## Usage

### Use the image to build an Android project

You can use this docker image to build your Android project with a single docker command:

```sh
cd <android project directory>  # change working directory to your project root directory.
docker run --rm -v $(pwd):/app matheussouza/docker-android-build-tools bash -c 'cd /app; ./gradlew build'
```

To build `.aab` bundle release, use `./gradlew bundleRelease`:

```sh
cd <android project directory>  # change working directory to your project root directory.
docker run --rm -v $(pwd):/app matheussouza/docker-android-build-tools bash -c 'cd /app; ./gradlew bundleRelease'
```

Run docker image with interactive bash shell:

```sh
docker run -it -v $(pwd):/app matheussouza/docker-android-build-tools /bin/bash
```

Add the following arguments to the docker command to cache the home gradle folder:

```sh
-v "$HOME/.dockercache/gradle":"/root/.gradle"
```

e.g.

```sh
docker run --rm -v $(pwd):/app  -v "$HOME/.dockercache/gradle":"/root/.gradle" matheussouza/docker-android-build-tools bash -c 'cd /project; ./gradlew build'
```

### Build an Android project with [Bitbucket Pipelines](https://bitbucket.org/product/features/pipelines)

If you have an Android project in a Bitbucket repository and want to use the pipeline feature to build it,
you can simply specify this docker image.
Here is an example of `bitbucket-pipelines.yml`:

```yml
image: matheussouza/docker-android-build-tools:latest

pipelines:
  default:
    - step:
        caches:
          - gradle
          - gradle-wrapper
          - android-emulator
        script:
          - bash ./gradlew assemble
definitions:
  caches:
    gradle-wrapper: ~/.gradle/wrapper
    android-emulator: $ANDROID_HOME/system-images/android-21
```

The caches are used to [store downloaded dependencies](https://confluence.atlassian.com/bitbucket/caching-dependencies-895552876.html) from previous builds, to speed up the next builds.

### Choose the Android Compile, Build Tools and SDK Tools version

Java 11 is installed.

| docker-android-build-tools version | Android Compile SDK | Build Tools version | SDK Tools version |
| ---------------------------------- | ------------------- | ------------------- | ----------------- |
| v1.0.0                             | 30                  | 30.0.3              | 8092744           |
| v1.2.0                             | 33                  | 33.0.0              | 9123335           |

If versions other than those listed are needed, just change the respective ENVs in Docerfile and [build the image](#build-the-Docker-Image).

## Build the Docker Image

If you want to build the docker image by yourself, you can use following command.
The image itself is around 1.3 GB, so check your free disk space before building it.

```sh
docker build -t docker-android-build-tools .
```

## Contribution

If you want to enhance this docker image or fix something,
feel free to send [pull request](https://github.com/matheus-souza/docker-android-build-tools/pull/new/master).

## References

-   [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
-   [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)
-   [Build your own image](https://docs.docker.com/engine/getstarted/step_four/)
-   [uber android build environment](https://hub.docker.com/r/uber/android-build-environment/)
-   [Docker Android Build Box](https://hub.docker.com/r/mingc/android-build-box/)
-   [Refactoring a Dockerfile for image size](https://blog.replicated.com/refactoring-a-dockerfile-for-image-size/)
-   [Label Schema](http://label-schema.org/)
