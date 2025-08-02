{ pkgs, ... }: {
  # Enable Hyprland at the system level
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    withUWSM = true;
    xwayland.enable = true; # kinda needed for electron apps sadly
  };

  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    hyprland
    kitty
    waybar
    libnotify
    networkmanagerapplet
    pavucontrol
    wl-clipboard
    clipse
    playerctl
    hyprpicker
    libqalculate
    hyprpaper
    hyprpolkitagent
    hyprsysteminfo
    hyprland-qt-support
    hyprcursor
    catppuccin-cursors.frappeRed

    # xdg-focused stuff
    xdg-utils
    shared-mime-info
    glib
    gtk3
    gtk4
  ];

  # these are actually tied to both nvidia and hyprland in part,
  # so PLEASE consult the hyprland wiki before building this on non novideo systems
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    XCURSOR_THEME = "catppuccin-macchiato-red-cursors";
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  # XDG Portal configuration
  xdg.portal.enable = true;
}
