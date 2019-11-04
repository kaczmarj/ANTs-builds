# ANTs-builds

Building Docker images of various versions of [ANTs](https://github.com/ANTsX/ANTs) from source. Images are hosted on [https://hub.docker.com/r/kaczmarj/ants/](https://hub.docker.com/r/kaczmarj/ants/).

This repository is used by [kaczmarj/neurodocker](https://github.com/kaczmarj/neurodocker).

Because the installation procedure is the same for most versions of ANTs, a single [Dockerfile](Dockerfile) is used to build multiple versions of ANTs.


# Available binaries

- [ants-Linux-centos6_x86_64-v2.3.1.tar.gz](https://dl.dropbox.com/s/hrm530kcqe3zo68/ants-Linux-centos6_x86_64-v2.3.2.tar.gz)
  - Actually from commit [3d416475b296321dfe5e6cf905e05f197f4afb52](https://github.com/ANTsX/ANTs/commit/3d416475b296321dfe5e6cf905e05f197f4afb52) (bugfix in `antsRegistration`).
- [ants-Linux-centos6_x86_64-v2.3.1.tar.gz](https://dl.dropbox.com/s/1xfhydsf4t4qoxg/ants-Linux-centos6_x86_64-v2.3.1.tar.gz)
- [ants-Linux-centos6_x86_64-v2.3.0.tar.gz](https://dl.dropbox.com/s/b3iymb9ml36ecp9/ants-Linux-centos6_x86_64-v2.3.0.tar.gz)
- [ants-Linux-centos6_x86_64-v2.2.0.tar.gz](https://dl.dropbox.com/s/e4g6r49e2gfnobn/ants-Linux-centos6_x86_64-v2.2.0.tar.gz)
- [ants-Linux-centos6_x86_64-v2.1.0.tar.gz](https://dl.dropbox.com/s/v0tu5wwl10q35u6/ants-Linux-centos6_x86_64-v2.1.0.tar.gz)


Compiled on CentOS 6.10 Docker image, with the following:

- glibc 2.12
- gcc/g++ 4.9.1
- make 3.81
- cmake 3.12.2


# Building ANTs

The following is the command used to build ANTs. Replace `$ants_version` necessary.

```bash
ants_version=v2.2.0

docker build -t ants:$ants_version \
--build-arg ants_version=$ants_version - < Dockerfile \
| tee logs/ANTs-Linux-centos6_x86_64-v${ants_version}.log
```


# Getting the binaries

The binaries can be pulled out of the Docker image by attaching a directory on the local machine to `/tmp/ants` and moving the contents of `/opt/ants` to `/tmp/ants`:

```shell
$ docker run --rm -v /path/to/local/ants:/tmp/ants ants:2.2.0 mv /opt/ants /tmp/ants
```

The binaries can be compressed before extracting to the local machine:

```bash
docker run --rm -v /home/ants:/tmp/ants-tar kaczmarj/ants:2.2.0 \
/bin/tar czvf /tmp/ants-tar/ants.tar.gz -C /opt ants
```
