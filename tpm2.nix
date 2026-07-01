{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tpm2-tss
    tpm2-tools
    sbctl
  ];

  #systemd.tpm2.enable = true;
  
#  boot.initrd.systemd = {
#    enable = true;
#    tpm2.enable = true;
#  };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
#  boot.loader.efi.canTouchEfiVariables = true;
#  boot.loader.efi.efiSysMountPoint = "/efi";

#  boot.loader.limine.enable = true;
#  boot.loader.limine.secureBoot.enable = true;
}
