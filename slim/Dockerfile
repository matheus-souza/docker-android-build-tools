FROM openjdk:11-slim

# Timezone
ENV TZ=America/Los_Angeles

# Set locale
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_CTYPE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN apt-get clean && \
    apt-get update -qq && \
    apt-get install -qq -y --no-install-recommends apt-utils locales locales-all && \
    locale-gen $LANG && \
    apt-get clean > /dev/null && \
    rm -rf /var/lib/apt/lists/ && \
    rm -rf /tmp/* /var/tmp/*

ENV DEBIAN_FRONTEND="noninteractive" \
    TERM=dumb \
    DEBIAN_FRONTEND=noninteractive

# Installing packages
RUN apt-get update -qq > /dev/null && \
    locale-gen "$LANG" > /dev/null && \
    apt-get install -qq --no-install-recommends \
        autoconf \
        bison \
        build-essential \
        cmake \
        curl \
        file \
        git \
        gpg-agent \
        less \
        libc6-dev \
        libffi-dev \
        libgdbm-dev \
        libgmp-dev \
        libmpc-dev \
        libmpfr-dev \
        libncurses5-dev \
        libreadline-dev \
        libssl-dev \
        libxslt-dev \
        libxml2-dev \
        libyaml-dev \
        lib32stdc++6 \
        lib32z1 \
        m4 \
        ncurses-dev \
        ocaml \
        pkg-config \
        ruby-full \
        software-properties-common \
        tzdata \
        unzip \
        wget \
        zip \
        tar \
        zipalign \
        s3cmd \
        python \
        zlib1g-dev > /dev/null && \
    echo "set timezone" && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get clean > /dev/null && \
    rm -rf /var/lib/apt/lists/ && \
    rm -rf /tmp/* /var/tmp/*

# Install fastlane
RUN gem install bundler && \
    gem install fastlane > /dev/null
