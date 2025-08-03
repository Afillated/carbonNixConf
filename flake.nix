{
  description = "a basic and very cluttered flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nh.url = "github:nix-community/nh";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
    # darkmatter-grub-theme = {
      # url = "gitlab:VandalByte/darkmatter-grub-theme";
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    

  };

  outputs =
    {
      self,
      nh,
      nixpkgs,
      zen-browser,
      # darkmatter-grub-theme,
      stylix,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "carbon" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hdabrosPC
            # darkmatter-grub-theme.nixosModule
            inputs.spicetify-nix.nixosModules.default
            stylix.nixosModules.stylix
          ];
        };
      };
    };
}
