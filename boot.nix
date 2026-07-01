{ config, lib, pkgs, modulesPath, ... }:

{
  boot.initrd = {
    availableKernelModules = [
    ];
    kernelModules = [
    ];
    luks = {
      devices."root" = {
        bypassWorkqueues = true;
        allowDiscards = true;
      };
    };
    systemd = {
      enable = true;
      tpm2.enable = false;
    };
  };

  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
	efiSysMountPoint = "/efi";
      };
      limine = {
        enable = true;
	secureBoot.enable = true;
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}