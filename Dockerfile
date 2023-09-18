FROM openjdk:17-slim

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

ENV ANDROID_HOME="/opt/android-sdk" 

ENV ANDROID_COMPILE_SDK="33" \
    ANDROID_BUILD_TOOLS="33.0.0" \
    ANDROID_SDK_TOOLS="9123335"

# Install Android SDK
RUN echo "sdk tools ${ANDROID_SDK_TOOLS}" && \
    wget --quiet --output-document=sdk-tools.zip \
        "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip" && \
    mkdir --parents "$ANDROID_HOME" && \
    unzip -q sdk-tools.zip -d "$ANDROID_HOME" && \
    rm --force sdk-tools.zip

# Install SDKs
# Please keep these in descending order!
# The `yes` is for accepting all non-standard tool licenses.
RUN mkdir --parents "$ANDROID_HOME/.android/" && \
    (echo '### User Sources for Android SDK Manager' > \
        "$ANDROID_HOME/.android/repositories.cfg" && \
    (yes | ("$ANDROID_HOME"/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses || true)))

#
# https://developer.android.com/studio/command-line/sdkmanager.html
#
RUN echo "platforms" && \
    "$ANDROID_HOME"/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "platforms;android-${ANDROID_COMPILE_SDK}" > /dev/null

RUN echo "platform tools" && \
    "$ANDROID_HOME"/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "platform-tools" > /dev/null

RUN echo "build tools" && \
    "$ANDROID_HOME"/cmdline-tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} \
        "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null
