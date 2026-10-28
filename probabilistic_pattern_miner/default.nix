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

  PAM=''${pam}/share/java/api-mining-1.0.jar'';

  buildPhase = ''
    head ${data} -n 1 >> temp.csv
    sort <( tail ${data} -n +2) | uniq >> temp.csv 
    python format_input.py temp.csv >> base.arff
    rm temp.csv
    java -jar $PAM -r 1 -f base.arff -o out.txt
    python format_output.py out.txt > $out
    rm out.txt
  '';

  installPhase = ''
  '';
}
