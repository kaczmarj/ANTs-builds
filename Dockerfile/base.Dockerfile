FROM centos:5.11

LABEL maintainer="Jakub Kaczmarzyk <jakubk@mit.edu"

# Due to CentOS 5 EOL, have to manually change repo info.
# See https://github.com/docker-library/official-images/issues/2815
RUN sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf \
    && sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/5.11|' /etc/yum.repos.d/*.repo \
    && rpm --import http://mirrors.mit.edu/centos/RPM-GPG-KEY-CentOS-5 \
    && rpm --import http://archives.fedoraproject.org/pub/archive/epel/RPM-GPG-KEY-EPEL-5 \
    && rpm -Uvh http://archives.fedoraproject.org/pub/archive/epel/5/x86_64/epel-release-5-4.noarch.rpm \
    #---------------------------
    # Install build dependencies
    #---------------------------
    && yum install -y -q curl \
                         gcc-c++ \
                         git \
                         make \
                         zlib-devel \
    && yum clean packages \
    && rm -rf /var/cache/yum/* && rm -rf /tmp \
    #--------------------
    # Install newer cmake
    #--------------------
    && curl -sSL -k https://cmake.org/files/v2.8/cmake-2.8.12.2-Linux-i386.tar.gz \
    | tar xz -C /opt

ENV PATH=/opt/cmake-2.8.12.2-Linux-i386/bin:$PATH
