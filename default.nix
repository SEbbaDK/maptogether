{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "flutter-test";
  buildInputs = with pkgs;
  [
    openjdk
    flutter
  ];
}
