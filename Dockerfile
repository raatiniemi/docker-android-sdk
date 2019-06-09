FROM debian:stretch AS builder
WORKDIR /build
ENV ANDROID_TOOLS_ZIP "sdk-tools-linux-4333796.zip"
RUN set -x \
  && apt-get update \
  && apt-get install -y curl unzip ca-certificates --no-install-recommends \
  && curl -O -Ls "https://dl.google.com/android/repository/${ANDROID_TOOLS_ZIP}" \
  && unzip -qq "${ANDROID_TOOLS_ZIP}" -d android

FROM openjdk:8
LABEL maintainer="Tobias Raatiniemi <raatiniemi@gmail.com>"

ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:${ANDROID_HOME}/tools/bin

COPY --from=builder /build/android ${ANDROID_HOME}

RUN set -x \
  && dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends \
  && yes | sdkmanager tools \
  && yes | sdkmanager platform-tools
