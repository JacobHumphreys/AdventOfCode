{
  description = "Flake Dependencies for my C/CPP template for building with Zig. Generated with AI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-2505,flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        pkgs2505 = import nixpkgs-2505 {
          inherit system;
        };
        llvm = pkgs2505.llvmPackages_latest;
      in {
        devShells.default = pkgs.mkShell {
            name = "clang-zig-shell";

            stdenv = llvm.libcxxStdenv;

            buildInputs = with pkgs;[
                llvm.clang-tools
                cmake
                ninja
                zig
                pkg-config
            ];

        shellHook = ''
        '';
        };
      }
    );
}

