FROM ubuntu:20.04
ENV TZ=America/Vancouver
ENV HOME=/home/drpai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# update and upgrade to latest & greatest
RUN apt -y update 
RUN apt -y upgrade
# Install packages
RUN apt-get -y install python libgl1-mesa-dev wget libopencv-dev \
                       python3-pip sudo unzip locales
# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
#create user drpai
RUN useradd -m drpai -s /bin/bash
RUN echo drpai:drpai | chpasswd
RUN usermod -aG sudo drpai
WORKDIR /home/drpai

USER drpai

#COPY files
COPY dwnld-fls.sh .
RUN ./dwnld-fls.sh
RUN unzip r20ut5035ej0184-drp-ai-translator.zip
RUN chmod +x DRP-AI_Translator-v1.84-Linux-x86_64-Install
RUN yes y | ./DRP-AI_Translator-v1.84-Linux-x86_64-Install
