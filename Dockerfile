FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools

RUN apt-get update && apt-get install -y \
    curl wget unzip git nodejs npm openjdk-17-jdk ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools

RUN wget -q \
    https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
    -O /tmp/cmdline-tools.zip

RUN unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools

RUN mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools \
    ${ANDROID_HOME}/cmdline-tools/latest

RUN yes | sdkmanager --licenses

RUN sdkmanager \
    "platform-tools" \
    "platforms;android-35" \
    "build-tools;35.0.0"

WORKDIR /app

COPY package.json .

RUN npm install --omit=dev

COPY server.js .

EXPOSE 10000

CMD ["node", "server.js"]
