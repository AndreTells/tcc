let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  pam = import ./pam_package/default.nix {};
  data = import ../filter_mined_data/default.nix;
in 
pkgs.stdenv.mkDerivation {
  name="probabilistic_pattern_miner";
  version="1.0";
  nativeBuildInputs = [ 
      pkgs.python3
      pkgs.zulu 
      pam
  ];
  src=./.;

  OUTPUT_FILE_NAME="probabilistic_patterns.txt";
  DATA=''${data}/${data.OUTPUT_FILE_NAME}'';
  PAM=''${pam}/share/java/api-mining-1.0.jar'';

  buildPhase = ''
    head $DATA -n 1 >> temp.csv
    sort <( tail $DATA -n +2) | uniq >> temp.csv 
    python main.py temp.csv >> base.arff
    rm temp.csv
    java -jar $PAM -r 1 -f base.arff -o $OUTPUT_FILE_NAME
  '';

  installPhase = ''
      mkdir $out
      mv $OUTPUT_FILE_NAME $out
  '';
}
