{host, ...}: let
  variables = import ../../hosts/${host}/variables.nix;
  consoleKeyMap = variables.consoleKeyMap or "us";
in {
  # Hostname
  networking.hostName = "${host}";

  # Nix settings
  nix = {
    settings = {
      download-buffer-size = 250000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    # GitHub API token for flake input resolution, to avoid the 60 req/hour
    # unauthenticated rate limit. Kept out of the store/repo: this file isn't
    # managed by Nix. `!include-ignore-errors` isn't valid syntax on this Nix
    # version (2.34.8) — plain `!include` already fails silently if the file
    # is absent, so rebuilds still work fine without it.
    extraOptions = ''
      !include /etc/nix/github-token.conf
    '';
  };

  # Timezone & Locale
  time.timeZone = "Asia/Tbilisi";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console.keyMap = "${consoleKeyMap}";
}
