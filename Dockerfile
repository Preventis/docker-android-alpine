FROM frolvlad/alpine-oraclejdk8-temporary:full
MAINTAINER Ben John <docker@benjohn.de>

ENV VERSION_SDK_TOOLS "3859397"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

RUN apk update
RUN apk add --no-cache bash bzip2 curl unzip git

RUN curl -s https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip > /sdk.zip
RUN unzip /sdk.zip -d /sdk
RUN rm -v /sdk.zip

RUN mkdir -p $ANDROID_HOME/licenses/
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license
RUN echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license

ADD packages.txt /sdk
RUN mkdir -p /root/.android
RUN touch /root/.android/repositories.cfg
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update

RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < /sdk/packages.txt && ${ANDROID_HOME}/tools/bin/sdkmanager ${PACKAGES}


# sonar scanner for code quality
ENV SONAR_SCANNER_VERSION 3.3.0.1492
RUN apk add --no-cache wget && \
    curl -L -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip && \
    ls -lh && \
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux && \
    cd /usr/bin && ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner sonar-scanner && \
    ln -s /usr/bin/sonar-scanner-run.sh /bin/gitlab-sonar-scanner
