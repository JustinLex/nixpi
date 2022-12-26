These files contain tooling to create a custom NixOS image for raspberry pi, directly from any x86 linux computer.

Only prerequisites are podman installed, root access, and 16G+ memory.

This method uses a lot of memory and requires full privileged root permissions to run the qemu vm.

If you have aarch64 node in you kubernetes cluster you can use the other folder to build the images using that.

## How to use

1. Run `sudo ./build.sh` to build the QEMU vm and open a nix environment inside podman
2. Run nano to edit /launch-vm.sh to increase disk to 8G, mem to 16G, and (optionally) cores to 16.
3. Run /launch-vm.sh to start the QEMU VM
4. Once the VM's shell is open, run the following command:
```commandline
nix-channel --update && nix-env -iA nixos.nixos-generators; img=$(nixos-generate -f sd-aarch64-installer --system aarch64-linux); cp $img /tmp/shared
```
5. You can then run `shutdown now` to stop the VM.
6. Your newly-built image should now be in `/tmp/nix-vm.XXXXXXXXXX/xchange/shared/`. Copy the image to `/output/`.
7. You can now exit the podman container, and you should have your freshly-built image.
