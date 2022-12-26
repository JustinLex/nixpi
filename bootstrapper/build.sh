#!/bin/bash

# Must be run as root in order to use KVM

podman build -t nixos_builder .
podman run --rm -it --privileged -v $PWD:/output:Z nixos_builder
