
{ config, pkgs, ... }:

{
  # /etc/nixos/configuration.nix
  virtualisation = {
    libvirtd = {
      enable = true;
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # For virt-install
    virt-manager

    dnsmasq

    # For lsusb
    usbutils
  ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddyserver/cache-handler@v0.16.0" ];
      hash = "sha256-8QCjp7iH8BA4nslN2es+gVVm3lRYRvSQJJXtvbVOMoI=";
    };
    globalConfig = ''
      cache
      	pki {
		ca local {
			name "Ruth Home CA"
			root_cn "Ruth Home CA - 2026 ECC Root"
                        intermediate_cn "Ruth Home CA - ECC Intermediate"
                }
	}
    '';
    virtualHosts."localhost".extraConfig = ''
      tls internal
      cache
      respond "Hello, world!"
    '';
    virtualHosts."www.home.internal".extraConfig = ''
      tls internal
      cache
      respond "Hello, I am www.ruth.home..."
    '';
    virtualHosts."assistant.home.internal".extraConfig = ''
      tls internal
      cache
      reverse_proxy http://192.168.122.39:8123
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.trustedInterfaces = [ "virbr0" "br0" ];

  networking.bridges.br0.interfaces = ["enp0s20f0u1"];
  networking.interfaces.enp0s20f0u1.useDHCP = false;
  networking.interfaces.br0.useDHCP = true;
}
