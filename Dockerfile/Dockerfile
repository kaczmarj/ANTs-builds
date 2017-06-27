# Dynamic Dockerfile that builds ANTs from source.
#
# Example:
#
#   docker build -t ants:2.1.0 --build-arg ants_version=2.1.0
#   --build-arg ants_git_hash=78931aa6c4943af25e0ee0644ac611d27127a01e .
FROM kaczmarj/ants:base

ARG ants_version
ARG ants_git_hash

ENV ANTS_VERSION=$ants_version \
    ANTS_GIT_HASH=$ants_git_hash

LABEL maintainer="Jakub Kaczmarzyk <jakubk@mit.edu>" \
      ants_version=$ants_version \
      ants_git_hash=$ants_git_hash

WORKDIR /tmp
RUN if [ -z "$ants_version" ] || [ -z "$ants_git_hash" ]; then \
        echo "ERROR: ants_version or ants_git_hash not defined"; exit 1; \
    fi \
    && echo "Building Docker image with ANTs version $ants_version from hash $ants_git_hash" \
    #-------------
    # Install ANTs
    #-------------
    && git clone git://github.com/stnava/ANTs.git \
    && cd ANTs \
    && git checkout $ants_git_hash \
    # Fix error in minor version in 2.2.0.
    # See https://github.com/kaczmarj/ANTs-builds/issues/4
    && if [ "$ants_version" = "2.2.0" ]; then \
          echo "Changing ANTs minor version to 2 from 1 ..."; \
          sed -i -e 's/_VERSION_MINOR 1/_VERSION MINOR 2/g' Version.cmake; \
    fi \
    && mkdir build && cd build && cmake .. && make -j 2 \
    && mkdir -p /opt/ants \
    && mv bin/* /opt/ants && mv ../Scripts/* /opt/ants \
    && rm -rf /tmp/*

ENV ANTSPATH=/opt/ants/ \
    PATH=/opt/ants:$PATH
