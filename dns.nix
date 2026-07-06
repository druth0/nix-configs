{ pkgs, ... }:

{
  services.bind = {
    enable = true;
    cacheNetworks = [ "127.0.0.0/24" "::1/128" "192.168.86.0/24" "192.168.1.0/24" ];
    zones = {
      "home.internal" = {
        master = true;
        allowQuery = [ "127.0.0.0/24" "::1/128" "192.168.86.0/24" "192.168.1.0/24" ];
        file = pkgs.writeText "home.internal" ''
          $ORIGIN ruth.home.
          $TTL    1h
          @            IN      SOA     ns1 hostmaster (
                                           1    ; Serial
                                           3h   ; Refresh
                                           1h   ; Retry
                                           1w   ; Expire
                                           1h)  ; Negative Cache TTL
                       IN      NS      ns1

          @            IN      A       192.168.86.15
                       IN      AAAA    2600:1702:6e60:b67f:a8e2:849f:3ee7:2745

          www          IN      A       192.168.86.15
                       IN      AAAA    2600:1702:6e60:b67f:a8e2:849f:3ee7:2745

          ns1          IN      A       192.168.86.15
                       IN      AAAA    2600:1702:6e60:b67f:a8e2:849f:3ee7:2745
        '';
      };
    };
  };
}
