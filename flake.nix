{
  description = "NixOS configuration with flakes";

  inputs = {
    # Nixpkgs
    nixpkgs-stable.url = "github:NixOS/nixpkgs/25.11-beta";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Use stable as default
    nixpkgs.follows = "nixpkgs-stable";

    # Hardware modules for NixOS
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      # Supported systems
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Helper to generate attrs for all systems
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Import custom library functions
      lib = import ./lib { inherit inputs; };
    in
    {
      # ==================================================================
      # NixOS Configurations
      # ==================================================================
      nixosConfigurations = {
        # Framework Laptop 16 - main workstation
        framework = lib.mkHost {
          hostname = "framework";
          system = "x86_64-linux";
        };

        # VM for testing configurations
        vm = lib.mkHost {
          hostname = "vm";
          system = "x86_64-linux";
        };
      };

      # ==================================================================
      # Home Manager Configurations (Standalone)
      # ==================================================================
      homeConfigurations = {
        # Personal user on framework
        "personal@framework" = lib.mkHome {
          username = "personal";
          hostname = "framework";
          system = "x86_64-linux";
        };

        # Work user on framework
        "work@framework" = lib.mkHome {
          username = "work";
          hostname = "framework";
          system = "x86_64-linux";
        };

        # Personal user on VM (for testing)
        "personal@vm" = lib.mkHome {
          username = "personal";
          hostname = "vm";
          system = "x86_64-linux";
        };
      };

      # ==================================================================
      # Overlays
      # ==================================================================
      overlays = import ./overlays { inherit inputs; };

      # ==================================================================
      # Custom Packages
      # ==================================================================
      packages = forAllSystems (
        system:
        import ./packages {
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );

      # ==================================================================
      # Development Shells
      # ==================================================================
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "nixos-config";
            packages = with pkgs; [
              # Nix tools
              nil
              nixfmt-rfc-style
              statix
              deadnix
              nix-tree

              # Secrets management
              sops
              age

              # General utilities
              git
              just
            ];

            shellHook = ''
              echo "╔══════════════════════════════════════════════════════════════╗"
              echo "║           NixOS Configuration Development Shell              ║"
              echo "╚══════════════════════════════════════════════════════════════╝"
              echo ""
              echo "System commands:"
              echo "  sudo nixos-rebuild switch --flake .#<host>  - Rebuild system"
              echo "  sudo nixos-rebuild test --flake .#<host>    - Test without switching"
              echo ""
              echo "Home Manager commands:"
              echo "  home-manager switch --flake .#<user>@<host> - Rebuild user config"
              echo ""
              echo "Development commands:"
              echo "  nix flake check       - Check flake"
              echo "  nix flake update      - Update inputs"
              echo "  nixfmt .              - Format all files"
              echo "  statix check .        - Lint configuration"
              echo "  deadnix .             - Find dead code"
              echo ""
              echo "Secrets commands:"
              echo "  sops secrets/secrets.yaml  - Edit secrets"
              echo ""
            '';
          };
        }
      );

      # ==================================================================
      # Formatter
      # ==================================================================
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
