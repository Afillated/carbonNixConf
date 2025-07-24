{
  description = "a basic and very cluttered flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nh.url = "github:nix-community/nh";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
    };
   };


  outputs = {
    self,
    nh,
    nixpkgs,
    zen-browser,
    grub2-themes,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "hdabrosPC" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hdabrosPC
          grub2-themes.nixosModules.default
          inputs.spicetify-nix.nixosModules.default
        ];
      };
    };
  };
}
