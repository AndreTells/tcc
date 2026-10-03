let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  glibc_functions_list = import ../list_glibc_functions/default.nix;
in 
pkgs.stdenv.mkDerivation {
  name="filter_mined_data_dev_shell";
  version="0.1";
  src=./.;

  nativeBuildInputs = [
    pkgs.clang-tools 
    pkgs.clang 
    glibc_functions_list
  ];

  # TODO swap test.txt for reference to module to generate .csv file
  OUTPUT_FILE_NAME = "filtered_graph.csv";
  CHUNCK_SIZE = 50;

  buildPhase = ''
    clang++ src/main.cpp
  '';

  installPhase = ''
    export GLIBC_FUNCTIONS_LIST_PATH=${glibc_functions_list}/${glibc_functions_list.OUTPUT_FILE_NAME}
    mkdir -p $out
    mkdir -p chuncks
    cd chuncks
    split -l $CHUNCK_SIZE <(tail -n +2 ../test.txt);
    ls | xargs -I {} sh -c "cat <(head ../test.txt -n 1) <(cat {}) > {}.csv; rm {}"
    cd ..
    touch $OUTPUT_FILE_NAME
    head test.txt -n 1 >> $OUTPUT_FILE_NAME
    ls chuncks | xargs -P 4 -I {} sh -c "./a.out ./chuncks/{}  >> $OUTPUT_FILE_NAME; echo 'done {}'"
    mv $OUTPUT_FILE_NAME $out
  '';
}
