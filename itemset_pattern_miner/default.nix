let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
in 
let 
  packageOverrides = pkgs.callPackage ./python-packages.nix { };
  python = pkgs.python3.override { inherit packageOverrides; };
  pythonWithPackages = python.withPackages (ps: [ ps.efficient-apriori ]);
  data = import ../filter_mined_data/default.nix;
in 
pkgs.stdenv.mkDerivation {
  name="itemset_pattern_miner";
  version="1.0";
  nativeBuildInputs = [ pythonWithPackages ];
  src=./.;

  DATA=''${data}/${data.OUTPUT_FILE_NAME}'';
  OUTPUT_FILE_NAME = "filtered_graph.csv";

  buildPhase = ''
    head $DATA -n 1 >> temp.csv
    sort <( tail $DATA -n +2) | uniq >> temp.csv 
    python3 itemset_pattern_miner.py temp.csv >> output.txt
    rm temp.csv
  '';


  installPhase = ''
    mkdir $out
    mv output.txt $out
  '';
}
