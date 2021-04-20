{
  pkgs ? import <nixpkgs> {},
  mkDerivation ? pkgs.stdenv.mkDerivation,
  crystal ? pkgs.crystal,
  ...
}:
let
  shard = builtins.readFile ./shard.yml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" shard);
in
mkDerivation {
  name = "maptogether-server";
  inherit version;
  buildInputs = [ crystal ];
}
