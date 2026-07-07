{ pkgs, ... }:
let
 outsideZone = pkgs.writeText "home.internal" ''
            $ORIGIN home.internal.
            $TTL    1h
            @            IN      SOA     ns1 hostmaster (
                                             1    ; Serial
                                             3h   ; Refresh
                                             1h   ; Retry
                                             1w   ; Expire
                                             1h)  ; Negative Cache TTL
                         IN      NS      ns1

            @            IN      A       192.168.86.15

            www          IN      A       192.168.86.15

            assistant    IN      A       192.168.86.15

            ns1          IN      A       192.168.86.15
          '';
 insideZone = pkgs.writeText "home.internal" ''
            $ORIGIN home.internal.
            $TTL    1h
            @            IN      SOA     ns1 hostmaster (
                                             1    ; Serial
                                             3h   ; Refresh
                                             1h   ; Retry
                                             1w   ; Expire
                                             1h)  ; Negative Cache TTL
                         IN      NS      ns1

            @            IN      A       192.168.1.245

            www          IN      A       192.168.1.245

            assistant    IN      A       192.168.1.245

            ns1          IN      A       192.168.1.245
          '';
in
{
  services.stubby = {
    enable = true;

    settings = pkgs.stubby.passthru.settingsExample // {
      listen_addresses = [
	"127.0.0.1@5353"
      ];
      upstream_recursive_servers = [
        {
	  address_data = "1.1.1.1";
	  tls_auth_name = "cloudflare-dns.com";
	}
	{
	  address_data = "1.0.0.1";
	  tls_auth_name = "cloudflare-dns.com";
	}
      ];
    };
  };

  services.bind = {
    enable = true;
    cacheNetworks = [ "127.0.0.0/24" "::1/128" "192.168.86.0/24" "192.168.1.0/24" ];
    listenOn = [ "127.0.0.1" "192.168.86.15" "192.168.1.245" ];

    # Allow queries from both of your local subnets
    extraOptions = ''
      allow-query { inside_net; outside_net; localhost; };
    '';

    # Define the Split-Horizon Views
    extraConfig = ''
      acl outside_net { 192.168.86.0/24; 127.0.0.0/24; };
      acl inside_net { 192.168.1.0/24; };

      # 1. View for the 192.168.86.x network
      view "inside" {
        match-clients { inside_net; };
        recursion yes;

	forwarders {
	  127.0.0.1 port 5353;
	};
	forward only;

        zone "home.internal" {
          type master;
          file "${insideZone}";
        };
      };

      # 2. View for the 192.168.1.x network
      view "outside" {
        match-clients { outside_net; };
        recursion yes;

	forwarders {
	  127.0.0.1 port 5353;
	};
	forward only;

        zone "home.internal" {
          type master;
          file "${outsideZone}";
        };
      };
    '';
  };

  # Open DNS ports in the firewall
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

}