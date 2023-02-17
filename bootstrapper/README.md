These files contain tooling to create a custom NixOS image for raspberry pi, directly from any x86 linux computer.

Only prerequisites are podman installed, root access, and 32G memory.

This method is quite manual, uses a lot of memory, and requires full privileged root permissions to run the qemu vm.

If you have an aarch64 node in your kubernetes cluster you can use the other folder to build the images using that.
Alternatively, if you have a nixos machine, that can also build this much easier.

## How to use

1. Start with bootstrapper/ as your working directory.
2. Run `sudo ./build.sh` to build the QEMU vm and open a nix environment inside podman
3. Run nano to edit /launch-vm.sh to increase disk to 8G, mem to 24G, and (optionally) cores to 16.
4. Run /launch-vm.sh to start the nixos VM
5. the vm will create a `nix-vm.XXXX` directory with an empty `xchng` folder in `output/`, outside of the VM. 
6. Copy in your nix configuration and related files into the `nix-vm.XXXX/xchng/` directory.
7. Then run the following command:
```commandline
nix-channel --update && nix-env -iA nixos.nixos-generators; img=$(nixos-generate -f sd-aarch64-installer --system aarch64-linux -c /tmp/shared/porygon.nix); cp $img /tmp/shared
```
6. You can then run `shutdown now` to stop the VM.
7. Your newly-built image should now be in `/tmp/nix-vm.XXXXXXXXXX/xchange/shared/`.
8. It is a good idea to `chmod -R 777 /tmp` here to make the image accessible to non-root outside of the container.
9. You can now exit the podman container, and you should have your freshly-built image in the output folder.
10. Decompress the image with `zstd -d path to image`, and then dd it onto your sd card.
