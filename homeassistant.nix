
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
    virtualHosts."localhost".extraConfig = ''
      tls internal
      respond "Hello, world!"
    '';
    virtualHosts."www.home.internal".extraConfig = ''
      tls internal
      respond "Hello, I am www.ruth.home..."
    '';
    virtualHosts."assistant.home.internal".extraConfig = ''
      tls internal
      reverse_proxy http://192.168.122.39:8123
    '';
  };


  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  networking.bridges.br0.interfaces = ["enp0s20f0u4"];
  networking.interfaces.br0 = {
    useDHCP = true;
  };
}
