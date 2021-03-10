{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "kmm-test";

  buildInputs = with pkgs;
  [
    gradle
    jdk
    kotlin
  ];
}
