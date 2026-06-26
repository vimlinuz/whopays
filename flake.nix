{
  description = "A Nix-flake-based Rust development environment for whopays";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    naersk.url = "github:nix-community/naersk";
  };

  outputs =
    { nixpkgs, naersk, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      naerskLib = pkgs.callPackage naersk { };
    in
    {
      packages.${system}.default = naerskLib.buildPackage {
        src = ./.;
        buildInputs = [ pkgs.openssl ];
        nativeBuildInputs = [ pkgs.pkg-config ];
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.rustc
          pkgs.cargo
          pkgs.clippy
          pkgs.rustfmt
          pkgs.openssl
          pkgs.cargo-watch
          pkgs.rust-analyzer
          # GUI dialog tool for build notifications
          pkgs.zenity
          pkgs.pnpm
          pkgs.prettier
          pkgs.anchor

          pkgs.nodejs
        ];
        nativeBuildInputs = [ pkgs.pkg-config ];

        shellHook = ''
          export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
        '';

      };
      formatter = pkgs.rustfmt;
    };
}
