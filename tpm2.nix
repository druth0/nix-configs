{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    clevis
    tpm2-tss
    tpm2-tools
    sbctl
  ];

  systemd.tpm2.enable = true;
  
  #boot.initrd.systemd = {
  #  enable = true;
  #  tpm2.enable = true;
  #};

  security.tpm2.enable = true;
}