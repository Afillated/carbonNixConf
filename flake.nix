{
  description = "a basic and very cluttered flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nh.url = "github:nix-community/nh";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

  outputs = {
    self,
    nh,
    nixpkgs,
    zen-browser,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "hdabrosPC" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hdabrosPC
        ];
      };
    };
  };
}
