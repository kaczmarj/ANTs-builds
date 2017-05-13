"""Build Docker images with various versions of ANTs.

Save log file for each build.
Restart Docker between each build.
"""
import os
import shlex
import subprocess
import time

dockerfile = os.path.abspath("Dockerfile/Dockerfile.build")

version_hashes = [("2.2.0", "0740f9111e5a9cd4768323dc5dfaa7c29481f9ef"),
                  ("2.1.0", "78931aa6c4943af25e0ee0644ac611d27127a01e"),
                  ("2.0.3", "c9965390c1a302dfa9e63f6ca3cb88f68aab329f"),
                  ("2.0.2", "7b83036c987e481b2a04490b1554196cb2fc0dab"),
                  ("2.0.1", "dd23c394df9292bae4c5a4ece3023a7571791b7d"),
                  ("2.0.0", "7ae1107c102f7c6bcffa4df0355b90c323fcde92"),]


def _get_one_build_cmd(version, git_hash, dockerfile=dockerfile):
    cmd = ("docker build -t kaczmarj/ants:{0} --build-arg ants_version={0}"
           " --build-arg ants_git_hash={1} -f {2} Dockerfile"
           "".format(version, git_hash, dockerfile))

    return shlex.split(cmd)


def _restart_application(app, sleep_interval=60):
    # Works on macOS.
    _cmd = "osascript -e 'tell application \"{app}\" to {action}'"

    cmd_quit = _cmd.format(app=app, action="quit")
    cmd_quit = shlex.split(cmd_quit)

    cmd_activate = _cmd.format(app=app, action="activate")
    cmd_activate = shlex.split(cmd_activate)

    subprocess.call(cmd_quit)
    time.sleep(sleep_interval)
    subprocess.call(cmd_activate)
    time.sleep(sleep_interval)


def build_one_image(version, git_hash):
    cmd = _get_one_build_cmd(version, git_hash)

    log_file = ("ANTs-Linux-centos5_x86_64-v{}-{}.log"
                "".format(version, git_hash[:7]))
    log_file = os.path.join('build_logs', log_file)

    with open(log_file, 'w') as fp:
        subprocess.call(cmd, stdout=fp)

    _restart_application("Docker")


def build_all_images():
    for version, git_hash in version_hashes:
        build_one_image(version, git_hash)



if __name__ == "__main__":
    build_all_images()
