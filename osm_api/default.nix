{
	pkgs ? import <nixpkgs> {},
	mkDerivation ? pkgs.stdenv.mkDerivation,
	dart ? pkgs.dart,
	...
}:
mkDerivation {
	name = "maptogether-osmapi";
	buildInputs = [ dart ];
}
