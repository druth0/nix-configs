{ config, pkgs, lib, ... }:

{
  # Enable sound.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.extraConfig = {
      bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
  };

  # Add the UCM files to the system environment
  environment.systemPackages = with pkgs; [
    alsa-utils
    # audio player
    amarok
    # system utils
    pavucontrol
    pwvucontrol
    sof-firmware
  ];
  
  hardware.alsa.enablePersistence = true;
}
