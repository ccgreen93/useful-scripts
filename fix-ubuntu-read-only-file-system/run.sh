#!/bin/bash

# eg:
# rm: cannot remove '/var/lib/docker/volumes/minikube/_data/log/alternatives.log': Read-only file system
# rm: cannot remove '/var/lib/docker/volumes/minikube/_data/log/private': Read-only file system
# rm: cannot remove '/var/lib/docker/volumes/minikube/_data/log/wtmp': Read-only file system
# rm: cannot remove '/var/lib/docker/volumes/minikube/_data/run': Read-only file system
# rm: cannot remove '/var/lib/docker/volumes/minikube/_data/spool/mail': Read-only file system
# rm: cannot remove '/var/lib/docker/volumes/plex_movies/opts.json': Read-only file system
# rm: cannot remove '/var/lib/docker/volumes/plex_movies/_data': Read-only file system


# re-mount filesystem rw
mount -o remount,rw /

systemctl stop docker # if not already stopped

# clear space, eg docker folder
rm -rf /var/lib/docker/*

systemctl start docker

