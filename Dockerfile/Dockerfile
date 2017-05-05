# Dynamic Dockerfile that builds ANTs from source.
#
# Example:
#
#   docker build -t ants:2.1.0 --build-arg ants_version=2.1.0
#   --build-arg ants_git_hash=78931aa6c4943af25e0ee0644ac611d27127a01e --force-rm .

FROM centos:6

ARG ants_version
ARG ants_git_hash

ENV ANTS_VERSION=$ants_version \
    ANTS_GIT_HASH=$ants_git_hash

LABEL maintainer="Jakub Kaczmarzyk <jakubk@mit.edu>" \
      ants_version=$ants_version \
      ants_git_hash=$ants_git_hash

WORKDIR /tmp

# Check that required arguments are defined.
RUN if [ -z "$ants_version" ] || [ -z "$ants_git_hash" ]; then \
        echo ERROR: ants_version or ants_git_hash not defined; exit 1; \
    fi \
    && echo "Building Docker image with ANTs version $ants_version from hash $ants_git_hash" \
    #---------------------------
    # Install build dependencies
    #---------------------------
    && yum install -y -q cmake \
                         gcc-c++ \
                         git \
                         make \
                         wget \
                         zlib-devel \
    && yum clean packages \
    && rm -rf /var/cache/yum/* \
    #-------------
    # Install ANTs
    #-------------
    && git clone git://github.com/stnava/ANTs.git \
    && cd ANTs \
    && git checkout $ants_git_hash \
    && mkdir build && cd build && cmake .. && make -j 2 \
    && mkdir -p /opt/ants \
    && cp bin/* /opt/ants && cp ../Scripts/* /opt/ants \
    && cd /tmp && rm -rf ANTs

ENV ANTSPATH=/opt/ants/ \
    PATH=/opt/ants:$PATH
