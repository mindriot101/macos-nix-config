{
  description = "home-manager configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jetbrains-updater = {
      url = "gitlab:genericnerdyusername/jetbrains-updater";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cert-info = {
      url = "github:simonrw/cert-info";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    hyprland.url = "github:hyprwm/Hyprland";

    # vim plugins
    plugin-vim-tmux-runner = {
      url = "github:christoomey/vim-tmux-runner";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    flake-utils,
    home-manager,
    jetbrains-updater,
    nix-index-database,
    vscode-server,
    cert-info,
    nur,
    nixvim,
    ...
  } @ inputs: let
    mkOverlays = system: [
      (final: prev: {
        keymapp = final.callPackage ./derivations/keymapp {pkgs = final;};
        listprojects = final.callPackage ./derivations/listprojects {};
        notify-wrapper = final.callPackage ./derivations/notify-wrapper {};
        database = nix-index-database.legacyPackages.${system}.database;
        monaspace = final.callPackage ./derivations/monaspace {};
        ansi = final.callPackage ./derivations/ansi {};
        wally = final.callPackage ./derivations/wally {};
        cert-info = cert-info.packages.${system}.default;
        gh-repo-url = final.callPackage ./derivations/gh-repo-url {};
        gh-rebase-pr = final.callPackage ./derivations/gh-rebase-pr {};
        # add flags to firefox devedition to use my default profile
        firefox-devedition = (
          final.symlinkJoin {
            name = "firefox-devedition";
            paths = [prev.firefox-devedition];
            buildInputs = [final.makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/firefox \
                --add-flags "-P simon"
            '';
          }
        );
      })
      # override the version of xattr for poetry
      (
        let
          python-overrides = self: {
            packageOverrides = _: pysuper: {
              cherrypy = pysuper.cherrypy.overrideAttrs (_: {
                doInstallCheck = !self.stdenv.isDarwin;
              });
              debugpy = pysuper.debugpy.overrideAttrs (_: {
                doInstallCheck = !self.stdenv.isDarwin;
              });
            };
          };
        in
          self: super: {
            python310 = super.python310.override (python-overrides self);
            python39 = super.python39.override (python-overrides self);
            python38 = super.python38.override (python-overrides self);
          }
      )
      jetbrains-updater.overlay
      nur.overlay
    ];

    getPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = mkOverlays system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          # for obsidian
          "electron-25.9.0"
        ];
      };

    mkNixOSConfiguration = system: name: let
      pkgs = getPkgs system;
    in
      nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        modules = [
          self.modules.nix
          (self.modules.nixos {inherit name;})
          home-manager.nixosModules.home-manager
          inputs.hyprland.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit system inputs;
              isLinux = pkgs.stdenv.isLinux;
              isDarwin = pkgs.stdenv.isDarwin;
            };

            home-manager.users.simon = {...}: {
              imports = [
                ./home/home.nix
                nixvim.homeManagerModules.nixvim
              ];
            };
          }
          nix-index-database.nixosModules.nix-index
          vscode-server.nixosModule
          ({
            config,
            pkgs,
            ...
          }: {
            services.vscode-server.enable = true;
          })
        ];
      };

    appendNixOSConfiguration = attrs: {
      system,
      name,
    }:
      attrs
      // {
        "${name}" = mkNixOSConfiguration system name;
      };

    nixOsConfigurations = systemDefinitions: {
      nixosConfigurations = builtins.foldl' appendNixOSConfiguration {} systemDefinitions;
    };

    darwinConfigurations = {
      darwinConfigurations = let
        system = "aarch64-darwin";

        pkgs = getPkgs system;
      in {
        mba = darwin.lib.darwinSystem {
          inherit pkgs system;
          modules = [
            self.modules.nix
            (self.modules.darwin {
              name = "mba";
            })
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit system inputs;
                isLinux = pkgs.stdenv.isLinux;
                isDarwin = pkgs.stdenv.isDarwin;
              };

              home-manager.users.simon = {...}: {
                imports = [
                  ./home/home.nix
                ];
              };
            }
            nix-index-database.darwinModules.nix-index
          ];
        };
      };
    };

    # these definitions are per system
    perSystemConfigurations = flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = getPkgs system;
      in {
        inherit pkgs;
        formatter = pkgs.alejandra;

        homeConfigurations = {
          simon = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./home/home.nix
              nixvim.homeManagerModules.nixvim
            ];
            # stop infinite recusion when trying to access
            # pkgs.stdenv.is{Linux,Darwin} from within a module
            extraSpecialArgs = {
              inherit system inputs;
              isLinux = pkgs.stdenv.isLinux;
              isDarwin = pkgs.stdenv.isDarwin;
            };
          };
          minimal = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./minimal/home.nix
              nixvim.homeManagerModules.nixvim
            ];
            # stop infinite recusion when trying to access
            # pkgs.stdenv.is{Linux,Darwin} from within a module
            extraSpecialArgs = {
              inherit system inputs;
              isLinux = pkgs.stdenv.isLinux;
              isDarwin = pkgs.stdenv.isDarwin;
            };
          };
        };
        devShells.default =
          pkgs.mkShell
          {
            buildInputs = with pkgs; [
              python310
              python310Packages.black
            ];
          };
      }
    );

    modules.modules = {
      # common module to configure nix
      nix = {...}: {
        nix.registry.nixpkgs.flake = nixpkgs;
        # set the system "nixpkgs" to the nixpkgs defined in this flake
        # https://dataswamp.org/~solene/2022-07-20-nixos-flakes-command-sync-with-system.html#_nix-shell_vs_nix_shell
        nix.nixPath = ["nixpkgs=/etc/channels/nixpkgs" "/nix/var/nix/profiles/per-user/root/channels"];
        environment.etc."channels/nixpkgs".source = nixpkgs.outPath;
      };
      nixos = {name ? ""}: import ./system/nixos/${name}/configuration.nix;
      darwin = {name ? ""}: import ./system/darwin/${name}/configuration.nix;
    };
  in
    nixOsConfigurations
    [
      {
        name = "astoria";
        system = "x86_64-linux";
      }
      {
        name = "macvm";
        system = "aarch64-linux";
      }
    ]
    // darwinConfigurations
    // perSystemConfigurations
    // modules;
}
