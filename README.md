# ANTs-builds

Building Docker images of various version of [ANTs](https://github.com/stnava/ANTs/) from source. Images are hosted on [https://hub.docker.com/r/kaczmarj/ants/](https://hub.docker.com/r/kaczmarj/ants/).

This repository is used by [kaczmarj/neurodocker](https://github.com/kaczmarj/neurodocker).

Because the installation procedure is the same for most versions of ANTs, a single [Dockerfile](Dockerfile/Dockerfile) is used to build multiple version of ANTs. This Dockerfile uses the Docker `ARG` instruction to take build arguments: the ANTs version and the corresponding `git` hash.



# Available binaries

Compiled on CentOS 5.11 Docker image

- glibc v2.5
- gcc v4.1.2
- make v3.81
- cmake v2.8.12.2


| version | download | build log | sha1 |
| --- | --- | --- | --- |
| 2.2.0 | [binaries](https://dl.dropbox.com/s/2f4sui1z6lcgyek/ANTs-Linux-centos5_x86_64-v2.2.0-0740f91.tar.gz) | [logs](build_logs/ANTs-Linux-centos5_x86_64-v2.2.0-0740f91.log?raw=1) | b7437beb85640cbcaa67872322f0d56a68de342a |
| 2.1.0 | [binaries](https://dl.dropbox.com/s/h8k4v6d1xrv0wbe/ANTs-Linux-centos5_x86_64-v2.1.0-78931aa.tar.gz) | [logs](build_logs/ANTs-Linux-centos5_x86_64-v2.1.0-78931aa.log?raw=1) | a01d4b9a9b9ec9dcaad2150c92325bbebe765af3 |
| 2.0.3 | [binaries](https://dl.dropbox.com/s/oe4v52lveyt1ry9/ANTs-Linux-centos5_x86_64-v2.0.3-c996539.tar.gz) | [logs](build_logs/ANTs-Linux-centos5_x86_64-v2.0.3-c996539.log?raw=1) | 9c5a464e9155a060ca7cc8ba7b177e1e6695cd1d |
| 2.0.2 | unavailable | [logs](build_logs/ANTs-Linux-centos5_x86_64-v2.0.2-7b83036.log?raw=1) | unavailable |
| 2.0.1 | unavailable | [logs](build_logs/ANTs-Linux-centos5_x86_64-v2.0.1-dd23c39.log?raw=1) | unavailable |
| 2.0.0 | [binaries](https://dl.dropbox.com/s/kgqydc44cc2uigb/ANTs-Linux-centos5_x86_64-v2.0.0-7ae1107.tar.gz) | [logs](build_logs/ANTs-Linux-centos5_x86_64-v2.0.0-7ae1107.log?raw=1) | fde5513f2cfd71fb3129991ccde94f463a6cf25d |




# Building ANTs

The following is the command used to build ANTs. Replace `$ants_version` and `$ants_git_hash` as necessary.

```bash
ants_version=2.2.0
ants_git_hash=0740f9111e5a9cd4768323dc5dfaa7c29481f9ef

build_log_file="ANTs-Linux-centos5_x86_64-v${ants_version}-${ants_git_hash:0:7}.log"

docker build -t kaczmarj/ants:$ants_version \
--build-arg ants_version=$ants_version \
--build-arg ants_git_hash=$ants_git_hash - < Dockerfile.build \
| tee ../build_logs/$build_log_file
```



# Getting the binaries

The binaries can be pulled out of the Docker image by attaching a directory on the local machine to `/opt/ants`. To get the binaries onto a local directory `/home/ants`, use the command `docker run --rm -v /home/ants:/opt/ants kaczmarj/ants:2.2.0`.

The binaries can be compressed before extracting to the local machine:

```bash
docker run --rm -v /home/ants:/tmp/ants-tar kaczmarj/ants:2.2.0 \
/bin/tar czvf /tmp/ants-tar/ants.tar.gz -C /opt ants
```



# Accessing labels within the Docker image

Each image has the labels `maintainer`, `ants_version`, and `ants_git_hash`. Access them using the `docker inspect` command:

```bash
> docker inspect -f '{{ index .Config.Labels "ants_git_hash" }}' kaczmarj/ants:2.2.0
0740f9111e5a9cd4768323dc5dfaa7c29481f9ef
```
