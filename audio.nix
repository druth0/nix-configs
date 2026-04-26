{ config, pkgs, lib, ... }:

let
  # This fetcher gets the specialized UCM configs for Chromebooks
  chromebook-ucm = pkgs.fetchFromGitHub {
    owner = "WeirdTreeThing";
    repo = "alsa-ucm-conf-cros";
    rev = "standalone";
    hash = "sha256-3TpzjmWuOn8+eIdj0BUQk2TeAU7BzPBi3FxAmZ3zkN8="; # Replace with actual hash
  };

  # Custom UCM package that overlays the official ALSA configs
  custom-ucm-conf = pkgs.stdenv.mkDerivation {
    pname = "alsa-ucm-conf-brya";
    version = "latest";
    src = chromebook-ucm;

    installPhase = ''
      mkdir -p $out/share/alsa/ucm2
      # Copy the base UCM files and then our Chromebook overrides
      cp -rf ucm2/* $out/share/alsa/ucm2/
    '';
  };
in
{
  # Enable sound.
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # Redrix often needs increased headroom to prevent crackling on Alder Lake
    wireplumber.extraConfig = {
      "main.conf.d/51-increase-headroom.conf" = {
        "monitor.alsa.rules" = [
          {
            matches = [ { "node.name" = "~alsa_output.*"; } ];
            actions = {
              update-props = {
                "api.alsa.headroom" = 1024;
              };
            };
          }
        ];
      };
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
  environment.systemPackages = [ 
    chromebook-ucm
    custom-ucm-conf
    pkgs.alsa-utils
    # audio player
    pkgs.amarok
    # system utils
    pkgs.pavucontrol
    pkgs.sof-firmware
  ];

  # Force the Intel DSP configuration for Chromebook audio routing
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=3
    options snd-sof-pci fw_path="intel/sof"
  '';

  # This links the Chromebook-specific UCM files where ALSA can find them
  environment.sessionVariables.ALSA_CONFIG_UCM2 = "${custom-ucm-conf}/share/alsa/ucm2";
  
  # Also link to /etc for non-session-aware processes
  environment.etc."alsa/ucm2".source = "${custom-ucm-conf}/share/alsa/ucm2";
}
