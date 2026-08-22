{ pkgs, ... }:
{
  # Generate headplane cookie secret (32 chars) on first deploy
  system.activationScripts.headplane-cookie-secret = {
    deps = [ "users" "groups" ];
    text = ''
      mkdir -p /var/lib/headplane
      chown headscale:headscale /var/lib/headplane
      chmod 750 /var/lib/headplane
      if [ ! -f /var/lib/headplane/.cookie_secret ]; then
        ${pkgs.coreutils}/bin/tr -dc 'A-Za-z0-9' < /dev/urandom | \
          ${pkgs.coreutils}/bin/head -c 32 > /var/lib/headplane/.cookie_secret
        chown headscale:headscale /var/lib/headplane/.cookie_secret
        chmod 600 /var/lib/headplane/.cookie_secret
      fi
    '';
  };

  services.headscale = {
    enable = true;
    address = "127.0.0.1";
    port = 8085;
    settings = {
      server_url = "https://hs.example.com";
      dns = {
        magic_dns = true;
        base_domain = "ts.example.com";
        nameservers.global = [ "1.1.1.1" "1.0.0.1" ];
      };
    };
  };

  services.headplane = {
    enable = true;
    settings = {
      server = {
        host = "127.0.0.1";
        port = 3000;
        base_url = "https://server.ts.example.com";
        cookie_secret_path = "/var/lib/headplane/.cookie_secret";
        cookie_secure = true;
      };
      headscale = {
        config_strict = false;
      };
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."hs.example.com" = {
      extraConfig = ''
        tls {
          issuer acme {
            disable_tlsalpn_challenge
          }
        }
        handle {
          reverse_proxy localhost:8085
        }
      '';
    };
    # Headplane admin — tailnet only via MagicDNS, TLS via Caddy internal CA
    virtualHosts."server.ts.example.com" = {
      extraConfig = ''
        bind 100.64.0.1 # replace with this node's actual tailscale IP
        tls internal
        redir / /admin permanent
        reverse_proxy localhost:3000
      '';
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 3478 ]; # STUN for DERP relay
  };
}
