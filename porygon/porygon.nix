# Nix config for Porygon, the RasPi3 that handles Zigbee and DNS for my home.

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  networking.hostName = "porygon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jlh =

  # Used for setting SSH authorized keys:
  # Get file with keys from github, read it as a string, split each line into separate strings, and drop any empty lines
  let keyList = builtins.split "\n" (builtins.readFile (builtins.fetchurl https://github.com/JustinLex.keys));
  isNotEmptyString = e: (builtins.isString e) && (builtins.lessThan 0 (builtins.stringLength e));
  githubKeys = builtins.filter isNotEmptyString keyList;

  in {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLVnXALyHX8qQX7gjzdaRbQqR3YMojIY/aMWuohd661 jlh@charmeleon"
    ] ++ githubKeys;
  };

  # Don't require a password for sudo
  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    k3s
  ];
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # Configure k3s
  services.k3s = {
    enable = true;
    role = "server";
  };


  system.activationScripts =
  let helloWorldManifest = builtins.path {
    name = "pod-hello-world-manifest";
    path = "/tmp/shared/pod-hello-world.yaml";
  }; # https://discourse.nixos.org/t/write-binary-file-to-nix-store/24732
  in {
    install_pod = ''
    mkdir -p /var/lib/rancher/k3s/server/manifests/
    cp ${helloWorldManifest} /var/lib/rancher/k3s/server/manifests/
    '';
  };
}

