let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
in 
pkgs.stdenv.mkDerivation {
  name="glibc_function_filter";
  version="1.0";
  src=./.;

  nativeBuildInputs = [
    pkgs.clang-tools 
    pkgs.clang 
  ];

  buildPhase = ''
    clang++ src/glibc_function_filter.cpp -o $out
  '';

  installPhase = ''
  '';
}
