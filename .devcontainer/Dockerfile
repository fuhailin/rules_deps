FROM ubuntu:20.04

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY library-scripts/sources-20.04LTS.list /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d/* && \
    ldconfig && apt-get update

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV BUILD_DIR=/workspaces

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get -y install --no-install-recommends lsb-release software-properties-common \
    gpg-agent \
    default-jdk \
    wget \
    vim \
    build-essential \
    libtool automake \
    pkg-config \
    xz-utils unzip \
    bzip2 \
    curl \
    git \
    zsh \
    aria2 \
    python3 \
    python3-dev \
    python3-pip \
    && apt-get clean && \
    ln -sf python3 /usr/bin/python && \
    ln -sf pip3 /usr/bin/pip

RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple \
    pip \
    wheel \
    numpy

# Install Bazelisk
RUN wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-$([ $(uname -m) = "aarch64" ] && echo "arm64" || echo "amd64") \
    && chmod +x /usr/local/bin/bazel

# Install oh-my-zsh now
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install LLVM
# RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
ARG LLVM_VERSION=14.0.0-x86_64-linux-gnu-ubuntu-18.04
ENV LLVM_HOME=/opt/llvm-14
ENV PATH=$PATH:$LLVM_HOME/bin
RUN wget https://rec-deeprec.oss-cn-beijing.aliyuncs.com/cpp3rd/clang%2Bllvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
    -P /tmp/library-scripts
RUN mkdir -p /opt/llvm-14 && \
    tar -xvf /tmp/library-scripts/clang+llvm-${LLVM_VERSION}.tar.xz && \
    mv clang+llvm-${LLVM_VERSION}/* /opt/llvm-14/ && \
    rm -rf clang+llvm-${LLVM_VERSION}

ENV CLANG_FORMAT=$LLVM_HOME/bin/clang-format

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
ENV PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
ENV MANPATH=/home/linuxbrew/.linuxbrew/share/man:$MANPATH
ENV INFOPATH=/home/linuxbrew/.linuxbrew/share/info:$INFOPATH
ENV BREW_DIR=/home/linuxbrew/
RUN brew install buildifier

RUN apt-get -y install bison \
    byacc \
    flex \
    gperf
# libssl-dev

RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
