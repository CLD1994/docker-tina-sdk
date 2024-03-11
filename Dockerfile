FROM ubuntu:20.04

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --yes \
    && apt-get upgrade --yes \
    && apt-get install --yes \
        build-essential \
        gcc-multilib \
        g++-multilib \
        flex \
        bison \
        libncurses-dev \
        libssl-dev \
        zlib1g-dev \
        git \
        gawk \
        gettext \
        rsync \
        unzip \
        file \
        wget \
        bc \
        libncursesw5 \
        u-boot-tools \
        lib32z1-dev \
        cpio \
        lsof \
        xxd \
        busybox \ 
        python3-distutils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 1
   
WORKDIR /workspace

# configure: error: you should not run configure as root
# (set FORCE_UNSAFE_CONFIGURE=1 in environment to bypass this check)
# reference https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem
ENV FORCE_UNSAFE_CONFIGURE=1
