{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/45a014f4796a0b3051652ae23d7bcb72823cb742.tar.gz") { config.android_sdk.accept_license = true; } }:
let
  btv = "28.0.3";
  android = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ btv ];
    platformVersions = [ "29" ];
  };
  sdk = "${android.androidsdk}";
in
pkgs.stdenv.mkDerivation
{
	name = "maptogether-client";
	buildInputs = with pkgs; [ gradle kotlin flutter ];
    ANDROID_SDK_ROOT = "${sdk}/libexec/android-sdk";
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/libexec/android-sdk/build-tools/${btv}/aapt2";
}
