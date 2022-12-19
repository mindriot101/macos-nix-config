{
  description = "home-manager configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    cftail.url = "github:simonrw/cftail";
    cftail.inputs.nixpkgs.follows = "nixpkgs";
    snslistener.url = "github:simonrw/aws-event-listener";
    snslistener.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, darwin, flake-utils, home-manager, cftail, snslistener, ... }:
    let
      mkNixOSConfiguration =
        name: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/nixos/${name}/configuration.nix
          ];
        };

      appendNixOSConfiguration =
        attrs: name: attrs // {
          "${name}" = mkNixOSConfiguration name;
        };

      nixOsConfigurations =
        names: {
          nixosConfigurations = builtins.foldl' appendNixOSConfiguration { } names;
        };

      # these definitions are per system
      perSystemConfigurations = flake-utils.lib.eachDefaultSystem (system:
        let
          overlays = [
            (final: _: {
              listprojects = final.callPackage ./derivations/listprojects { };
              ntfy = final.callPackage ./derivations/ntfy { };
              cftail = cftail.packages.${system}.default;
              snslistener = snslistener.packages.${system}.default;
              notify-wrapper = final.callPackage ./derivations/notify-wrapper { };
              notion = final.callPackage ./derivations/notion { };
            })
            # override the version of xattr for poetry
            (
              let
                python-overrides = {
                  packageOverrides = _: pysuper: {
                    cherrypy = pysuper.cherrypy.overrideAttrs (_: rec {
                      doInstallCheck = !pkgs.stdenv.isDarwin;
                    });
                    debugpy = pysuper.debugpy.overrideAttrs (_: rec {
                      doInstallCheck = !pkgs.stdenv.isDarwin;
                    });
                  };
                };
              in
              _: super: {
                python310 = super.python310.override python-overrides;
                python39 = super.python39.override python-overrides;
                python38 = super.python38.override python-overrides;

                # enable a specific python version to run debugpy
                python-for-debugging = super.python3.withPackages (ps: [
                  ps.debugpy
                ]);
              }
            )
          ];

          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
            config.input-fonts.acceptLicense = true;
          };

        in
        {
          homeConfigurations = {
            simon = home-manager.lib.homeManagerConfiguration {
              pkgs = pkgs;
              modules = [
                ./home/home.nix
                # per program configuration
                ./home/bat.nix
                ./home/direnv.nix
                ./home/fish.nix
                ./home/fzf.nix
                ./home/gh.nix
                ./home/git.nix
                ./home/gpg.nix
                ./home/helix.nix
                ./home/home-manager.nix
                ./home/jq.nix
                ./home/neovim.nix
                ./home/tmux.nix
                ./home/vscode.nix
                ./home/dark-mode.nix
              ];
            };
          };
          darwinConfigurations = {
            mba = darwin.lib.darwinSystem {
              system = "aarch64-darwin";
              modules = [
                ./system/darwin/configuration.nix
              ];
              inputs = { inherit darwin pkgs; };
            };
          };
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              python310
              python310Packages.black
            ];
          };
        }
      );
    in
    nixOsConfigurations [
      "nixos"
      "astoria"
    ] // perSystemConfigurations;
}
