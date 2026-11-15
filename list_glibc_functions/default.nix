let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  parser = import ./header_parser.nix;
in 
pkgs.stdenv.mkDerivation
{
  name="glibc_functions_list";
  version="1.0";
  src=./.;

  nativeBuildInputs = with pkgs; [
    clang 
    llvmPackages_latest.libclang
    ripgrep
  ];

  buildPhase = ''
    clang++ src/main.cpp -lclang
  '';

  installPhase = ''
    export GLIBC_PATH=${pkgs.glibc.dev}
    export temp=$(mktemp)
    rg '(# error|#error)' --files-without-match ${pkgs.glibc.dev}/include -g '!finclude' -g '!bits/' | xargs -P 100 -I {} sh -c "${parser} {} 2>/dev/null >> $temp|| echo {}" 
    cat $temp | sort | uniq > $out
    rm $temp
  '';
}
