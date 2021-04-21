{
  pkgs ? import ../nixpkgs.nix {},
  mkDerivation ? pkgs.stdenv.mkDerivation,

  # Dependencies
  crystal ? pkgs.crystal_0_36,
  shards ? pkgs.shards,
  pkg-config ? pkgs.pkg-config,
  openssl ? pkgs.openssl,
  ...
}:
let
  shard = builtins.readFile ./shard.yml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" shard);
in
mkDerivation {
  name = "maptogether-server";
  inherit version;
  buildInputs = [ shards pkg-config crystal openssl ];
}
