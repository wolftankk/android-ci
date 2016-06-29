FROM ubuntu:16.04
MAINTAINER wolftankk <wolftankk@plu.cn>

ENV VERSION_SDK_TOOLS "25.1.7"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"
ENV DEBIAN_FRONTEND noninteractive

RUN cp -f /etc/apt/sources.list /etc/apt/sources.list.bak

RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
# RUN echo "deb-src http://mirrors.ustc.edu.cn/ubuntu/ xenial-backports main restricted universe multiversea" >> /etc/apt/sources.list

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        curl \
        html2text \
        openjdk-8-jdk \
        libc6-i386 \
        lib32stdc++6 \
        lib32gcc1 \
        lib32ncurses5 \
        lib32z1 \
        unzip \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/ssl/certs/java/cacerts; \
        /var/lib/dpkg/info/ca-certificates-java.postinst configure

ADD http://dl.google.com/android/repository/tools_r${VERSION_SDK_TOOLS}-linux.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
        rm -v /tools.zip

# ndk
ADD http://dl.google.com/android/repository/android-ndk-r12-linux-x86_64.zip /ndk.zip
RUN unzip -qq /ndk.zip -d /n && \
    mv /n/android-ndk-r12 /ndk 
#& \ rm -v /ndk.zip
ENV PATH "$PATH:/ndk"

RUN (while [ 1 ]; do sleep 5; echo y; done) | ${ANDROID_HOME}/tools/android update sdk -u -a -t platform-tools,extra-android-m2repository,extra-android-support,extra-google-google_play_services,extra-google-m2repository,addon-google_apis-google-22,addon-google_apis-google-23,android-22,android-23,build-tools-23.0.1,build-tools-23.0.2,build-tools-23.0.3,build-tools-22.0.1
