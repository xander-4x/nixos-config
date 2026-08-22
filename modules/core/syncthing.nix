{username, ...}: {
  services.syncthing = {
    enable = false;
    user = "${username}";
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
    overrideDevices = true;
    settings = {
      # Fill in with `syncthing --device-id` (or the GUI) on each device
      devices = {
        "laptop".id = "REPLACE-WITH-DEVICE-ID-1-REPLACE-WITH-DEVICE-ID-1";
        "server".id = "REPLACE-WITH-DEVICE-ID-2-REPLACE-WITH-DEVICE-ID-2";
        "phone".id  = "REPLACE-WITH-DEVICE-ID-3-REPLACE-WITH-DEVICE-ID-3";
      };
      folders = {
        "notebook" = {
          label = "Notebook";
          path = "/home/${username}/Documents/Notebook";
          devices = [ "laptop" "server" "phone" ];
        };
      };
    };
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
