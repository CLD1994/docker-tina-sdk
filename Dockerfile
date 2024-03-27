ARG BOARD=base

FROM ubuntu:20.04 as tina-sdk-base

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
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
        repo \
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

ENV REPO_URL="https://mirrors.tuna.tsinghua.edu.cn/git/git-repo"

WORKDIR /workspace

# configure: error: you should not run configure as root
# (set FORCE_UNSAFE_CONFIGURE=1 in environment to bypass this check)
# reference https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem
ENV FORCE_UNSAFE_CONFIGURE=1


FROM tina-sdk-base as tina-sdk-v853

ARG AW-OL-USERNAME
ARG AW-OL-PASSWORD

RUN repo init -u https://${AW-OL-USERNAME}:${AW-OL-USERNAME}@sdk.aw-ol.com/git_repo/V853Tina_Open/manifest.git -b master -m tina-v853-open.xml


FROM tina-sdk-v853 as tina-sdk-yuzukilizard

ARG GIT-BRANCH=master

RUN git clone --branch ${GIT-BRANCH} --depth 1  https://github.com/YuzukiHD/Yuzukilizard.git \
    && cp -rf Yuzukilizard/Software/BSP/* ./ \
    && rm -rf Yuzukilizard

FROM tina-sdk-${BOARD}



