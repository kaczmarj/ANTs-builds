# ANTs-builds

Building Docker images of various version of [ANTs](https://github.com/stnava/ANTs/) from source. Images are hosted on https://hub.docker.com/r/kaczmarj/ants/.

Because the installation procedure is the same for most version of ANTs, a single [Dockerfile](Dockerfile/Dockerfile) is used to build multiple version of ANTs. This Dockerfile uses the Docker `ARG` instruction to take build arguments: the ANTs version and the corresponding `git` hash.
