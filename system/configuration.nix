{
  inputs,
  config,
  pkgs,
  username,
  hostname,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      extra-substituters = [ "https://cache.garnix.io" ];
      extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ firefox ];
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/var/lib/docker2";
      ipv6 = true;
      fixed-cidr-v6 = "fd00::/80";
    };
  };

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [
      # "127.0.0.1"
      # "::1"
      "1.1.1.1"
    ];
    hosts = {
      "127.0.0.1" = [
        "example.com"

        # To test subdomains.
        "site1.example.com"
        "site2.example.com"
        "site3.example.com"
        "site4.example.com"
        "site5.example.com"

        # Using .test TLD
        "site1.test"
        "site2.test"
        "site3.test"
        "site4.test"
        "site5.test"
      ];
    };

  };

  # services.dnscrypt-proxy2 = {
  #   enable = true;
  #   settings = {
  #     ipv6_servers = true;
  #     require_dnssec = true;
  #     sources.public-resolvers = {
  #       urls = [
  #         "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
  #         "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
  #       ];
  #       cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
  #       minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
  #     };
  #     server_names = [
  #       "cloudflare"
  #       "cloudflare-ipv6"
  #       "google"
  #       "google-ipv6"
  #     ];
  #   };
  # };

  # systemd.services.dnscrypt-proxy2.serviceConfig = {
  #   StateDirectory = "dnscrypt-proxy";
  # };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=0"
      # "video=eDP-1:2650x1600@60"
    ];
    kernelPackages = pkgs.linuxPackages_6_11;
  };

  # QMK keyboard
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];
  environment.systemPackages = with pkgs; [
    via
    man-pages
    man-pages-posix
  ];

  # CPU and GPU stuff
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];
  services.hardware.bolt.enable = true;
  # services.xserver.displayManager.gdm = {
  #   enable = true;
  #   wayland = true;
  # };
  services.getty.autologinUser = username;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "Hyprland";
        user = username;
      };
    };
    vt = 1;
  };

  # services.xserver.desktopManager.gnome.enable = true;
  # Manually enable some services gnome used to
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.localsearch.enable = true;

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.pantum-driver ];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
      };
    };
  };
  hardware.enableAllFirmware = true;

  security.rtkit.enable = true;
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.properties = {
  #       ["bluez5.enable-sbc-xq"] = true,
  #       ["bluez5.enable-msbc"] = true,
  #       ["bluez5.enable-hw-volume"] = true,
  #       ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  #     }
  #   '';
  # };

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  environment.pathsToLink = [ "/share/zsh" ];
  fonts.fontconfig.enable = true;

  programs = {
    steam.enable = true;

    # enable installing zsh at the system level to set the users default terminal. Everything else configuration wise is done in home manager.
    zsh = {
      enable = true;
      enableCompletion = false;
    };
    # Same for hyprland, install to system to ensure wayland sessions are propagated correctly.
    hyprland.enable = true;

    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    direnv = {
      enable = true;
      # re-use system shell
      direnvrcExtra = "export SHELL=$SHELL";
    };

    file-roller.enable = true; # archive manager
    gnome-disks.enable = true; # disk manager

    # Add `open in foot` entry to nautilus
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "foot";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # WLR_NO_HARDWARE_CURSORS = "1";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "24.05"; # Did you read the comment?
}
