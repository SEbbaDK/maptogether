{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-20.09.tar.gz") {}, ... }:
pkgs.stdenv.mkDerivation {
  name = "maptogether-client-ios";
  buildInputs = with pkgs; [ xcbuild cocoapods ];
}
