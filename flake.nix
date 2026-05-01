{
  description = "nwiizo dotfiles managed with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fish-ssh-agent = {
      url = "github:danhper/fish-ssh-agent";
      flake = false;
    };
    fish-fastdir = {
      url = "github:danhper/fish-fastdir";
      flake = false;
    };
    fish-abbreviation-tips = {
      url = "github:gazorby/fish-abbreviation-tips";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      username = "nwiizo";
      system = "aarch64-darwin";
    in
    {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home
          {
            home.username = username;
            home.homeDirectory = "/Users/${username}";
          }
        ];
      };
    };
}
