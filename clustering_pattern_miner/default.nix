let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
in 
let 
  packageOverrides = pkgs.callPackage ./python-packages.nix { };
  python = pkgs.python313.override { inherit packageOverrides; };
  pythonWithPackages = python.withPackages (ps: with ps; [ 
    kmodes
    pandas
  ]);
  data = import ../filter_mined_data/default.nix;
in 
pkgs.stdenv.mkDerivation {
  name="clustering_pattern_miner";
  version="1.0";
  nativeBuildInputs = [ pythonWithPackages ];
  src=./.;

  OUTPUT_FILE_NAME = "cluster"; 

  buildPhase = ''
    python3 clustering.py ${data} >> $out
  '';


  installPhase = ''
  '';
}
