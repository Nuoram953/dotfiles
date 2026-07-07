{
  description = "Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

    outputs = { nixpkgs, home-manager, ... }:
    {
    homeConfigurations."nuoram-arch" =
        home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
            system = "x86_64-linux";
        };
        modules = [./hosts/nuoram-arch/home.nix];
        };

    # homeConfigurations."nuoram-mac" =
    #     home-manager.lib.homeManagerConfiguration {
    #     pkgs = import nixpkgs {
    #         system = "aarch64-darwin";
    #     };
    #     modules = [ ./home.nix ];
    #     };
    };
}
