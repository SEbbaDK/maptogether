{ pkgs ? import ../nixpkgs.nix { }
, mkDerivation ? pkgs.stdenv.mkDerivation
, # Dependencies
  crystal ? pkgs.crystal
, shards ? pkgs.shards
, pkg-config ? pkgs.pkg-config
, openssl ? pkgs.openssl
, crystal2nix ? pkgs.crystal2nix
, buildCrystalPackage ? pkgs.crystal.buildCrystalPackage
, ...
}:
let
  shard = builtins.readFile ./shard.yml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" shard);
in
(buildCrystalPackage {
  pname = "maptogether-server";
  inherit version;

  buildInputs = [ openssl openssl.out ];
  src = ./.;

  format = "shards";
  shardsFile = ./shards.nix;

  # Disable tests until they work
  doCheck = false;
  doInstallCheck = false;

  crystalBinaries.maptogether-server.src = "src/maptogether-server.cr";
})
# This line enables quicker builds
.overrideAttrs (old: { buildPhase = builtins.replaceStrings [ "--release" ] [ "" ] old.buildPhase; })
