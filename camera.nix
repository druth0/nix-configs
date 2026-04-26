{ config, pkgs, lib, ... }:

{
  # Camera stuff
  #services.udev.extraRules = ''
  #  SUBSYSTEM=="intel-ipu6-psys", MODE="0660", GROUP="video"
  #'';

  # https://jgrulich.cz/2024/08/19/making-pipewire-default-option-for-firefox-camera-handling/
  #services.pipewire.wireplumber.extraConfig."disable-v4l2" = {
  #  "wireplumber.profiles" = {
  #    "main" = {"monitor.v4l2" = "disabled";};
  #  };
  #};

  #environment.systemPackages = with pkgs; [
    # Camera
    #ipu6-camera-hal
    #ipu6-camera-bins
    #ipu6ep-camera-hal
    #ivsc-firmware
    #libcamera
    #libcamera-qcam
    #gst_all_1.icamerasrc-ipu6ep
    #v4l2-relayd
  #];

  # 1. Kernel and Firmware
  # Brya needs latest kernel for Alder Lake fixes and the IPU6 driver stack
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  
  #hardware.enableRedistributableFirmware = true;

  hardware.firmware = [ pkgs.ivsc-firmware ];
  boot.kernelModules = [ 
    "intel_vsc" 
    "intel_vsc_csi" 
    "intel_vsc_psi"
    "mei_vsc" 
    "mei_vsc_hw"
  ];
  # Ensure the kernel has the out-of-tree modules
  #boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback config.boot.kernelPackages.ivsc-driver ];
  
  # Ensure the loopback device is created at boot for the relay to grab
  #boot.kernelModules = [ "v4l2loopback" ];
  #boot.extraModprobeConfig = ''
  #  options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  #'';

  # 2. Enable the IPU6 specific module
  # In recent NixOS versions, there is a dedicated hardware option for this.
  hardware.ipu6 = {
    enable = true;
    # 'ipu6ep' is the correct platform for Alder Lake (Brya)
    platform = "ipu6ep";
  };

  # 3. Kernel Parameters for ChromeOS/Brya hardware
  boot.kernelParams = [
    # Required for some Redrix sensors to probe correctly in ACPI
    "int3403_thermal.force_load=1"
    # Ensure the IPU6 isys can address enough memory
    "intel_ipu6_isys.enable_64bit_dma=1"
    # This enables the IPU bridge which is required for 
    # the sensors to show up in media-ctl
    "intel_ipu6_isys.ipu_bridge=1"
  ];

  # 4. PipeWire / Libcamera Bridge
  # Standard apps won't see the camera without this.
  #services.pipewire = {
    #libcamera.enable = true;
    # Wireplumber needs to be told to look for the libcamera nodes
    #extraConfig.pipewire."10-camera" = {
    #  "context.modules" = [
    #    {
    #      name = "libpipewire-module-libcamera";
    #      args = { };
    #    }
    #  ];
    #};
  #};

  services.pipewire.wireplumber.extraConfig."10-libcamera" = {
    "monitor.libcamera" = "required";
  };

  # 5. Firefox/Chromium WebRTC Fix
  # Most browsers won't talk to the raw libcamera nodes yet.
  # We use v4l2-relayd or a loopback to bridge it.
  services.v4l2-relayd.instances = {
    ipu6 = {
      enable = true;
    };
  };

  # 6. Crucial: The Tuning Files
  # Without these, the camera usually just shows a green/purple screen.
  # These are usually specific to the sensor (e.g., ov2740).
  #environment.etc."libcamera/ipu6".source = "${pkgs.ipu6-camera-bins}/etc/libcamera/ipu6";

  xdg.portal = {
    enable = true;
    #config.common.default = "*";
  };
}
