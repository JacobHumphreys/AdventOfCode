{
  description = "devShell using flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    devShells.x86_64-linux.default = pkgs.mkShell.override {
      stdenv = pkgs.llvmPackages_latest.libcxxStdenv;
    } {
      packages = with pkgs;[
        llvmPackages_latest.clang-tools
        cmake
        ninja
        zig
      ];

      shellHook = ''
      '';
    };
  };
}
