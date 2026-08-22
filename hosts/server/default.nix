{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./user.nix
    ./zram.nix

    # Core system modules (shared)
    ../../modules/core

    # Server-specific modules
    ../../modules/server

    # Containers (podman)
    ../../modules/virtualisation/podman.nix

    # Headscale VPN control server (optional — remove if not needed)
    ./headscale.nix
  ];

  system.stateVersion = "25.11";
}
