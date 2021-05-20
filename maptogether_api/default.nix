{ pkgs ? import ../nixpkgs.nix { }
, mkDerivation ? pkgs.stdenv.mkDerivation
, dart ? pkgs.dart
, ...
}:
let
  pubspec = builtins.readFile ./pubspec.yaml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" pubspec);
in
mkDerivation {
  pname = "maptogether-api";
  inherit version;
  buildInputs = [ dart ];
}
