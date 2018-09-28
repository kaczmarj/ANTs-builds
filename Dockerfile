# Dynamic Dockerfile that builds ANTs from source.
#
# Example:
#
#   docker build -t ants:2.2.0 --build-arg ants_version=2.2.0
#   --build-arg ants_git_hash=0740f9111e5a9cd4768323dc5dfaa7c29481f9ef .
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
          # See https://github.com/stnava/ANTs/commit/e170c7c4695643c0f0e08e619778ef45b6b4632c
          echo "Fixing version bug (changing minor version from 1 to 2) ..." \
          && sed -i -e 's/set(${PROJECT_NAME}_VERSION_MINOR 1)/set(${PROJECT_NAME}_VERSION_MINOR 2)/g' Version.cmake \
          && sed -i -e 's/set(LIBRARY_VERSION_INFO 2.1.0)/set(LIBRARY_VERSION_INFO 2.1.0)/g' CMakeLists.txt \
          && sed -i -e 's/set(CPACK_PACKAGE_VERSION 2.1.0)/set(CPACK_PACKAGE_VERSION 2.2.0)/g' CMakeLists.txt \
          && sed -i -e 's/set(CPACK_PACKAGE_VERSION_MINOR 1)/set(CPACK_PACKAGE_VERSION_MINOR 2)/g' CMakeLists.txt; \
    fi \
    && mkdir build && cd build && cmake .. && make -j1 \
    && mkdir -p /opt/ants \
    && mv bin/* /opt/ants && mv ../Scripts/* /opt/ants \
    && rm -rf /tmp/*

ENV ANTSPATH=/opt/ants/ \
    PATH=/opt/ants:$PATH
