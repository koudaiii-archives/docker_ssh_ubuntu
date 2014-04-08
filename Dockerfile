# SSH-DOCKER-UBUNTU
#
# VERSION       1

FROM ubuntu:12.04
MAINTAINER koudaiiii "cs006061@gmail.com"

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

#Dev tools for all Docker
RUN apt-get -y install git vim

#install ssh
RUN apt-get -y install openssh-server
RUN mkdir /var/run/sshd
RUN chmod 711 /var/run/sshd
# setup sshd
ADD ./sshd_config /etc/ssh/sshd_config

#install user
RUN apt-get -y install passwd sudo

# useradd user,name to koudaiii
RUN useradd --create-home -s /bin/bash koudaiii ;\
    adduser koudaiii sudo ;\
    echo "koudaiii:password" | chpasswd;

# Set .ssh
RUN mkdir -p /home/koudaiii/.ssh;chown koudaiii /home/koudaiii/.ssh; chmod 700 /home/koudaiii/.ssh
ADD ./authorized_keys /home/koudaiii/.ssh/authorized_keys
RUN chown koudaiii /home/koudaiii/.ssh/authorized_keys;chmod 600 /home/koudaiii/.ssh/authorized_keys

# setup sudoers
RUN echo "koudaiii ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/koudaiii
RUN chmod 440 /etc/sudoers.d/koudaiii

# Change TimeZone
RUN mv /etc/localtime /etc/localtime.org
RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# expose for sshd
EXPOSE 2222
CMD ["/usr/sbin/sshd","-D"]
