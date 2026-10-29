let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  base = ./base.arff;
  pam = import ./pam_package/default.nix {};
  formatter = import ./formatter.nix;
  binPath = pkgs.lib.makeBinPath [
    pkgs.coreutils
    pkgs.zulu
  ];
in 
let 
  pam_jar=''${pam}/share/java/api-mining-1.0.jar'';
  input_formatter = ''${formatter}/bin/format_input'';
  output_formatter = ''${formatter}/bin/format_output'';
in
pkgs.writeTextFile {
  name="probabilistic_pattern_miner";
  version="1.0";
  executable=true;

  text = ''
    #!${pkgs.runtimeShell}
    export PATH="${binPath}:$PATH"
    rm probabilistic_pattern_miner_patterns.txt;
    head $1 -n 1 >> temp.csv;
    sort <( tail $1 -n +2) | uniq >> temp.csv ;
    touch in.arff;
    chmod a+w in.arff;
    cat ${base} >> in.arff;
    ${input_formatter} temp.csv >> in.arff;
    rm temp.csv;
    java -jar ${pam_jar} -r 120 -f in.arff -o temp.txt;
    rm in.arff;
    ${output_formatter} temp.txt > probabilistic_pattern_miner_patterns.txt;
    rm temp.txt;
  '';
}
