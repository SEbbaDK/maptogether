{
  pkgs ? import <nixpkgs> {},
  mkDerivation ? pkgs.stdenv.mkDerivation,
  dart ? pkgs.dart,
  ...
}:
let
  pubspec = builtins.readFile ./pubspec.yaml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" pubspec);
in
mkDerivation {
  name = "maptogether-osmapi";
  inherit version;
  buildInputs = [ dart ];
}
