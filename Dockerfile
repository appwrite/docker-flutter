FROM ubuntu:20.04

LABEL maintainer="team@appwrite.io"

ENV ANDROID_COMMAND_LINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip"
ENV ANDROID_HOME="~/.android"
ENV ANDROID_SDK_HOME="/opt/android-sdk"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"

ENV FLUTTER_REPO_URL="https://github.com/flutter/flutter.git"
ENV FLUTTER_HOME="/opt/flutter"
ENV PATH="$ANDROID_HOME/tools/bin:$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

# install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN \
    apt-get update \
    && apt-get -y install --no-install-recommends \
        curl \
        git \
        lib32stdc++6 \
        openjdk-8-jdk-headless \
        unzip \
    && apt-get --purge autoremove \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# flutter
RUN git clone -b master $FLUTTER_REPO_URL $FLUTTER_HOME

# android sdk
RUN curl -s $ANDROID_COMMAND_LINE_TOOLS_URL -o commandlinetools.zip \
    && mkdir $ANDROID_SDK_HOME \
    && unzip commandlinetools.zip -d $ANDROID_SDK_HOME \
    && rm commandlinetools.zip

RUN mkdir $ANDROID_HOME \
    && echo 'count=0' > $ANDROID_HOME/repositories.cfg \
    && yes "y" | sdkmanager --licenses > /dev/null \
    && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
    && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
    && yes "y" | sdkmanager "platform-tools" \
    && yes "y" | sdkmanager "emulator" \
    && yes "y" | sdkmanager "system-images;android-$ANDROID_VERSION;google_apis_playstore;$ANDROID_ARCHITECTURE" \
    && flutter doctor -v \
    && chown -R root:root /opt
