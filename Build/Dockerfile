FROM ubuntu:20.04
ENV TZ=America/Vancouver
ENV WORK=/home/yocto/rzv_vlp_v3.0.6
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# update and upgrade to latest & greatest
RUN apt-get -y update && apt-get -y upgrade
# Install packages
RUN apt-get -y install --no-install-recommends \
				gawk wget git-core diffstat unzip texinfo \
				gcc-multilib build-essential chrpath socat cpio python python3 \
				python3-pip python3-pexpect xz-utils debianutils iputils-ping \
				python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 \
				xterm p7zip-full libyaml-dev screen ncurses-bin libncurses-dev \
				device-tree-compiler locales vim git findutils exuberant-ctags \
				cscope tmux sudo tree file
# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
#create user yocto
RUN useradd -m yocto -s /bin/bash
RUN echo yocto:yocto | chpasswd
RUN usermod -aG sudo yocto
WORKDIR /home/yocto

USER yocto

#COPY files
COPY prepare_yocto_env.sh /home/yocto
RUN mkdir -p $WORK/build/downloads && \
    mkdir -p $WORK/out && \
    /home/yocto/prepare_yocto_env.sh

COPY start.sh /home/yocto/
COPY exec.sh /home/yocto/
# copy mistysom layer from the submodule
COPY --chown=yocto:yocto meta-mistysom $WORK/meta-mistysom
COPY --chown=yocto:yocto meta-econsys $WORK/meta-econsys
COPY --chown=yocto:yocto meta-iotedge $WORK/meta-iotedge
COPY --chown=yocto:yocto meta-rust $WORK/meta-rust
COPY --chown=yocto:yocto meta-clang $WORK/meta-clang

CMD ["/home/yocto/exec.sh"]
