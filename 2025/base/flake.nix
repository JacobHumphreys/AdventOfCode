{
  description = "devShell using flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.nixpkgs2511.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs , nixpkgs2511}: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    pkgs2511 = import nixpkgs2511 { system = "x86_64-linux"; };


    zigCompileCommands = pkgs.fetchFromGitHub {
      owner = "the-argus";
      repo = "zig-compile-commands";
      rev = "70fb439897e12cae896c071717d7c9c382918689";
      sha256 = "dUtfifueNJkwBvbossc7Eohv6QbH+9vzCiMReghOgu8="; # replace with real hash
    };

  in {
    devShells.x86_64-linux.default = pkgs.mkShell.override {
      stdenv = pkgs.llvmPackages_latest.libcxxStdenv;
    } {
      packages = with pkgs;[
        llvmPackages_latest.clang-tools
        cmake
        ninja
        pkgs2511.zig
      ];

      shellHook = ''
      '';
    };

    packages.x86_64-linux.default = pkgs.stdenv.mkDerivation {
        pname = "AdventOfCode";
        version = "1.0";

        src = ./.;

        buildInputs = with pkgs2511;[
            zig 
        ];

        preBuild = ''
        '';

        buildPhase = ''
            export HOME=$PWD
            export ZIG_GLOBAL_CACHE_DIR=$PWD/.cache
            export ZIG_LOCAL_CACHE_DIR=$PWD/.zig-cache/

            mkdir -p $ZIG_GLOBAL_CACHE_DIR/p/zig_compile_commands-0.0.1-OZg5-ULBAABTh3NXO3WXoSUX1474ez0EouuoT2yDANhz
            cp -r ${zigCompileCommands}/* $ZIG_GLOBAL_CACHE_DIR/p/zig_compile_commands-0.0.1-OZg5-ULBAABTh3NXO3WXoSUX1474ez0EouuoT2yDANhz/
            ls ./include/
            zig build;
        '';

        installPhase = ''
            mkdir -p $out/bin
            cp $PWD/zig-out/bin/aoc_2025 $out/bin/AdventOfCode
        '';
    };
  };
}
