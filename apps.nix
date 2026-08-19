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
    "firefox-bin"
    "firefox-bin-unwrapped"
    "ipu6-camera-bins"
    "ipu6-camera-bins-unstable"
    "ivsc-firmware"
    "ivsc-firmware-unstable"
  ];

  environment.systemPackages = with pkgs; [
    emacs-pgtk
    python3
    git
    plan9port

    # web
    # librewolf now insecure with no maintainer
    chromium
    firefox-bin
    google-chrome
    wget
    curl
    dig
    inetutils
    gemini-cli
    antigravity

    kdePackages.bluedevil

    # power
    acpi
    powertop
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

    # Android
    android-tools
    adb-sync
    adbfs-rootless

    # Librem5
    uuu

    # Analogue Pocket
    pupdate

    # Theming
    sweet
    candy-icons
    sweet-nova
    sweet-folders

    # MariaDB
    mycli

    coreboot-utils

    # Office
    kmymoney
    gnucash
    libreoffice
  ];

  programs.firefox.enable = true;
  programs.git.enable = true;
  programs.htop.enable = true;
  programs.less.enable = true;
  programs.tmux.enable = true;
  programs.screen.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  #services.desktopManager.gnome.enable = true;

  # Enable plasma!
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = false;
  services.displayManager.plasma-login-manager.enable = true;
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.thermald.enable = true;
  services.keyd.enable = true;
  powerManagement.powertop.enable = true;

  networking.wireless = {
    enable = true;
    dbusControlled = true;
  };

  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
