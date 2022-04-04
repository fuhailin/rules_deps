FROM ubuntu:20.04

ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY library-scripts/sources-20.04LTS.list /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d/* && \
    ldconfig && apt-get update

COPY library-scripts/*.sh /tmp/library-scripts/

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

RUN apt-get -y install xz-utils unzip \
    bzip2 \
    curl \
    git \
    zsh \
    aria2

# Install LLVM
# RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
ARG LLVM_VERSION=14.0.0-x86_64-linux-gnu-ubuntu-18.04
ENV LLVM_HOME=/opt/llvm-14
ENV PATH=$PATH:$LLVM_HOME/bin
RUN aria2c -s12 \
    -x12 \
    https://cpp3rd-1256340525.cos.ap-beijing.myqcloud.com/clang%2Bllvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
    -d /tmp/library-scripts \
    --download-result=full
RUN mkdir -p /opt/llvm-14 && \
    tar -xvf /tmp/library-scripts/clang+llvm-${LLVM_VERSION}.tar.xz && \
    mv clang+llvm-${LLVM_VERSION}/* /opt/llvm-14/ && \
    rm -rf clang+llvm-${LLVM_VERSION}

# Install oh-my-zsh now
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ENV PATH=/usr/lib/llvm-14/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV CLANG_FORMAT=$LLVM_HOME/bin/clang-format
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
