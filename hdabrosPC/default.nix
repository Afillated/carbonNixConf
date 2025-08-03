# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../modules/system/hyprland.nix

    # ../modules/dev/fish.nix
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  boot = {
    # Enable GRUB
    loader.grub = {
      enable = true;
      # version = 2;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = false;
      useOSProber = true; # Detect Windows
      default = "saved"; # Default to last booted OS
      configurationLimit = 8;
      # darkmatter-theme = {
      # enable = true;
      # style = "nixos";
      # icon = "color";
      # resolution = "1080p";
      # };
    };
    # kernelPackages = pkgs.linuxPackages_latest;

    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;

    # Add NTFS support
    supportedFilesystems = [ "ntfs" ];
  };

  networking.hostName = "carbon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  #Enable Stylix
  stylix = {
    enable = true;
    image = ../wallpaper;
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 36;
    };
  };

  services.greetd.enable = true;
  programs.regreet.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # programs.hyprland.enable = true; # enable Hyprland

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;
    # nixpkgs.config.nvidia.acceptLicense = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carbon = {
    isNormalUser = true;
    description = "Afillatedcarbon";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # packages = with pkgs; [
    # kdePackages.kate
    #  thunderbird
    # ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  #Install and Configuration for Steam
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      protontricks.enable = true;
    };

    gamemode = {
      enable = true;
      settings.general.inhibit_screensaver = 0;
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--backend sdl"
        # "--rt"
      ];
    };
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;
  #Allows flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.nh = {
    enable = true;
    flake = "/home/carbon/carbonflake";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 8";
    };
  };

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        # ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];

      # theme = spicePkgs.themes.burntSienna;
      # colorScheme = "mocha";
    };

  # programs.starship = {
  # enable = true;
  # enableFishIntegration = true;
  # };

  # programs.fish.enable = true;
  #add kde connect
  # programs.kdeconnect.enable = true;

  #Setting starship as interactive shell
  programs.bash.interactiveShellInit = ''eval "$(starship init bash)"'';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix
    wget
    vesktop
    # spotify
    git
    inputs.zen-browser.packages.${pkgs.system}.twilight
    starship
    gitui
    grub2
    # spicetify-cli
    android-tools
    pmbootstrap
    # kitty
    nil
    walker
    mako
    unzip
    zellij
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
