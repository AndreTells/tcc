let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  data = ../repos.txt;
in 
pkgs.stdenv.mkDerivation
{
  name="repo_list_clone";
  version="1.0";
  src=./.;

  nativeBuildInputs = with pkgs; [
    git
  ];

  installPhase = ''
    mkdir -p $out
    cd $out
    cat ${data} | xargs -I {} -P 100 git clone --depth 1 {}
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "";
}
