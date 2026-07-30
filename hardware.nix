{ config, lib, pkgs, modulesPath, ... }:

{
  #boot.kernelParams = [
  #  "xe.force_probe=7d45"
  #  "i915.force_probe=!7d45"
  #];

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
  };

  swapDevices = [{
    device = "/var/swap";
    size = 8*1024;
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    bluetooth.enable = true;

    xpadneo.enable = true;

    intelgpu.driver = "i915";

    sensor.iio.enable = true;

    firmware = with pkgs;[
      sof-firmware
      linux-firmware
      wireless-regdb
    ];
  };
}

