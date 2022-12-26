#!/bin/bash

# Must be run as root in order to use KVM

podman build -t nixos_bootstrapper .
podman run --rm -it --privileged -v $PWD/../output:/tmp:Z nixos_bootstrapper
