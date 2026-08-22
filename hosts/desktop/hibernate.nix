{ ... }: {
  # Btrfs subvolume for swapfile — no compression, no CoW
  # Before first deploy: create @swap subvolume and swapfile manually.
  # Then fill in the UUID below: blkid /dev/sdX (your LUKS device or plain partition)
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "btrfs";
    options = [ "subvol=@swap" "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
  }];

  # LUKS decrypted device + btrfs physical offset for hibernate resume.
  # Get offset after creating swapfile:
  #   sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  boot.resumeDevice = "/dev/mapper/cryptroot";
  boot.kernelParams = [ "resume_offset=XXXXXXXXXX" ];

  # suspend-then-hibernate: fast resume if woken quickly,
  # full power-off after 30 min — ideal for backpack transport
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";
}
