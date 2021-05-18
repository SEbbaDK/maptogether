{ pkgs ? import ../nixpkgs.nix { config.android_sdk.accept_license = true; }
, includeAndroid ? true
, ...
}:
let
  btv = "29.0.2";
  android = pkgs.androidenv.composeAndroidPackages {
    buildToolsVersions = [ btv ];
    platformVersions = [ "30" ];
  };
  sdk = "${android.androidsdk}";
  pubspec = builtins.readFile ./pubspec.yaml;
  version = builtins.head (builtins.match ".*version: ([0-9.]+).*" pubspec);
in
pkgs.stdenv.mkDerivation
{
  name = "maptogether-client";
  inherit version;
  buildInputs = with pkgs; [
    jdk11
    flutter
  ];
  ANDROID_SDK_ROOT = (if includeAndroid then "${sdk}/libexec/android-sdk" else "");

  # This used to be be necessary, but now it seems to break builds
  # GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/libexec/android-sdk/build-tools/${btv}/aapt2";
}
