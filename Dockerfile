# Dynamic Dockerfile that builds ANTs from source.
#
# Example:
#
#   docker build -t ants:2.2.0 --build-arg ants_version=2.2.0

FROM centos:6@sha256:12f2e9aa55e245664e86bfdf4eb000ddc316b48d9aa63c3c98ba886416868e49 as builder

ARG NPROC=1

WORKDIR /tmp
RUN curl -fsSLO https://raw.githubusercontent.com/cms-sw/cms-docker/master/slc6-vanilla/RPM-GPG-KEY-cern \
    && rpm --import RPM-GPG-KEY-cern \
    && curl -fsSL -o /etc/yum.repos.d/slc6-scl.repo http://linuxsoft.cern.ch/cern/scl/slc6-scl.repo \
    && yum install -y -q \
          curl \
          devtoolset-3-gcc-c++ \
          git \
          make \
          zlib-devel \
    && yum clean packages \
    && rm -rf /var/cache/yum/* && rm -rf /tmp/* \
    && curl -fsSL https://cmake.org/files/v3.12/cmake-3.12.2.tar.gz | tar -xz \
    && cd cmake-3.12.2 \
    && source /opt/rh/devtoolset-3/enable \
    && printf "\n\n+++++++++++++++++++++++++++++++++\n\
BUILDING CMAKE WITH $NPROC PROCESS(ES)\n\
+++++++++++++++++++++++++++++++++\n\n" \
    && ./bootstrap --parallel=$NPROC -- -DCMAKE_BUILD_TYPE:STRING=Release \
    && make -j$NPROC \
    && make install \
    && cd .. \
    && rm -rf *

ARG ants_version

ENV ANTS_VERSION=$ants_version
WORKDIR /src
RUN if [ -z "$ants_version" ]; then \
        echo "ERROR: ants_version not defined" && exit 1; \
    fi \
    && echo "Compiling ANTs version $ants_version" \
    && git clone git://github.com/stnava/ANTs.git ants \
    && cd ants \
    && git fetch origin --tags \
    && git checkout tags/$ants_version \
    && mkdir build \
    && cd build \
    && source /opt/rh/devtoolset-3/enable \
    && printf "\n\n++++++++++++++++++++++++++++++++\n\
BUILDING ANTS WITH $NPROC PROCESS(ES)\n\
++++++++++++++++++++++++++++++++\n\n" \
    && cmake .. \
    && make -j$NPROC \
    && mkdir -p /opt/ants \
    && mv bin/* /opt/ants && mv ../Scripts/* /opt/ants \
    && cd .. \
    && rm -rf build

FROM centos:7.5.1804

COPY --from=builder /opt/ants /opt/ants

ENV ANTSPATH=/opt/ants/ \
    PATH=/opt/ants:$PATH

LABEL maintainer="Jakub Kaczmarzyk <jakubk@mit.edu>" \
      ants_version=$ants_version
