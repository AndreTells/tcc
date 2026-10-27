let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  repos = import ../repo_list_clone/default.nix;
in 
pkgs.stdenv.mkDerivation
{
  name="glibc_functions_list";
  version="1.0";
  src=./.;

  nativeBuildInputs = with pkgs; [
    clang 
    llvmPackages_latest.libclang
  ];

  buildPhase = ''
    clang++ src/main.cpp -lclang
  '';

  installPhase = ''
    find -L ${repos} -name '*.c' | xargs -I {} ./a.out {} ${repos} >> base.csv
    mv base.csv $out
  '';
}
