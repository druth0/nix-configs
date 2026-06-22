{ config, pkgs, lib, ... }:

{
  # Proprietary packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "antigravity"
    "android-sdk-platform-tools"
    "platform-tools"
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
    "google-chrome"
    "ipu6-camera-bins"
    "ipu6-camera-bins-unstable"
    "ivsc-firmware"
    "ivsc-firmware-unstable"
  ];

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    emacs-pgtk
    python3
    git
    plan9port

    # web
    # librewolf now insecure with no maintainer
    chromium
    google-chrome
    wget
    curl
    gemini-cli
    antigravity

    kdePackages.bluedevil

    # power
    acpi
    powertop
    minicom
    lm_sensors

    # FW tools
    dmidecode
    flashrom
    fw-ectool
    firmware-updater
    pciutils
    usbutils

    # Core utils
    uutils-diffutils
    uutils-findutils
    uutils-coreutils-noprefix
    linux-firmware

    # Games
    openmw
    supertux
    supertuxkart

    # WiFi
    iw
    wireless-regdb

    # Extra wayland WMs
    #wio
    # Sway stuff
    #bemenu
    #swayr
    #swaybg
    #swayidle
    #swaylock
    #swaytools
    #swaysettings
    #mako
    # wayfire
    #wayfire-with-plugins
    #wayfirePlugins.wayfire-plugins-extra
    #alacritty
    #alacritty-theme

    # Android
    android-tools
    adb-sync
    adbfs-rootless

    # Librem5
    uuu
    python314Packages.requests
    python314Packages.tqdm
    python314Packages.python-jenkins

    # Analogue Pocket
    pupdate

    # Theming
    sweet
    candy-icons
    sweet-nova
    sweet-folders
  ];

  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.kdeconnect.enable = true;
  programs.less.enable = true;
  #programs.ssh.startAgent = true;
  programs.tmux.enable = true;
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  wrapperFeatures.base = true;
  #};

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable plasma!
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  # Enable cosmic
  services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;

  services.thermald.enable = true;
  services.keyd.enable = true;
  powerManagement.powertop.enable = true;

  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
