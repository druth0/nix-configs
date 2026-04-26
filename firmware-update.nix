{ config, lib, pkgs, ... }:

{
  boot.kernelParams = [
    "iomem=relaxed"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    libusb1
  ];

  environment.systemPackages = with pkgs; [
    dmidecode
    flashrom
  ];
}