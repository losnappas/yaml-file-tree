{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    systems.url = "github:nix-systems/default";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
      ];
      systems = import inputs.systems;
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {

          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.

          devenv.shells.default = {
            name = "my-project";

            # https://devenv.sh/reference/options/
            languages.nix.enable = true;
            languages.python.enable = true;
            languages.python.venv.enable = true;
            # languages.python.libraries = [
            #     pkgs.zlib
            #     pkgs.stdenv
            # ];

            packages = with pkgs; [
              python312Packages.python-lsp-server
              python312Packages.python-lsp-ruff
            ];

            # enterShell = "export LD_LIBRARY_PATH=${pkgs.zlib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH";
          };

          formatter = pkgs.nixfmt-rfc-style;

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          packages.default = pkgs.python3Packages.buildPythonApplication {
              pname = "yaml-file-tree";
              version = "1.0.0";
              src = ./.;
              format = "pyproject";
              buildInputs = [ pkgs.python3Packages.setuptools pkgs.python3Packages.wheel ];
          };
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
