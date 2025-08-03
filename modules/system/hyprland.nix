{ pkgs, ... }:
{
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
    hyprcursor # Uncommented this - it's needed!
    hyprshot

    # catppuccin-cursors.frappeRed
    bibata-cursors
    # xdg-focused stuff
    xdg-utils
    shared-mime-info
    glib
    gtk3
    gtk4

    # Additional packages for better cursor support
    gsettings-desktop-schemas # For GTK cursor theme support
    adwaita-icon-theme # Fallback icon theme
  ];

  # these are actually tied to both nvidia and hyprland in part,
  # so PLEASE consult the hyprland wiki before building this on non novideo systems
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";

    # Cursor configuration
    # XCURSOR_THEME = "Bibata-Modern-Classic";
    # XCURSOR_SIZE = "24";
    # HYPRCURSOR_THEME = "Bibata-Modern-Classic"; # Uncommented this
    # HYPRCURSOR_SIZE = "24";

    # Additional cursor/theme variables for better app support
    # GTK_THEME = "Adwaita:dark"; # Helps with consistent theming
    # QT_QPA_PLATFORMTHEME = "gtk3"; # Makes Qt apps use GTK cursor theme

    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # for nvidia/wayland i think
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
  # programs.dconf.enable = true;
  # Set up fontconfig and cursor themes system-wide
  # fonts.fontconfig.enable = true;
}
