{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/45a014f4796a0b3051652ae23d7bcb72823cb742.tar.gz") { config.android_sdk.accept_license = true; } }:
let
  btv = "30.0.3";
  android = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ "28.0.3" "29.0.2" btv ];
    platformVersions = [ "28" "29" ];
  };
  sdk = "${android.androidsdk}";
in
pkgs.stdenv.mkDerivation
{
	name = "maptogether-client";
    buildInputs = with pkgs; [
      kotlin
      gradle
      flutter
    ];
    ANDROID_SDK_ROOT = "${sdk}/libexec/android-sdk";
    GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/libexec/android-sdk/build-tools/${btv}/aapt2";
}
