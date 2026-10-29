let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};

  binPath = pkgs.lib.makeBinPath [ pkgs.coreutils];
  glibc_functions_list = import ../list_glibc_functions/default.nix;
  glibc_filter = import ./glibc_filter.nix;
  eliminate_singles = import ./eliminate_singles.nix;
  CHUNCK_SIZE = "100";
in 
pkgs.writeTextFile {
  name="filter_mined_data";
  version="1.0";
  executable=true;

  text = ''
    #!${pkgs.runtimeShell}
    export PATH="${binPath}:$PATH";
    export GLIBC_FUNCTIONS_LIST_PATH=${glibc_functions_list}/${glibc_functions_list.OUTPUT_FILE_NAME};
    file_path=$(readlink -f $1)
    mkdir -p chuncks;
    cd chuncks;
    split -l ${CHUNCK_SIZE} <(tail -n +2 $file_path);
    echo 'finished split';
    ls | xargs -P 100 -I {} sh -c "cat <(head $file_path -n 1) <(cat {}) > {}.csv; rm {}; echo 'formatted {}'";
    cd ..;
    head $file_path -n 1 >> temp.csv;
    ls chuncks | xargs -P 100 -I {} sh -c "${glibc_filter} ./chuncks/{}  >> temp.csv; echo 'done {}'";
    rm chuncks -r;
    head temp.csv -n 1 >> temp2.csv;
    sort <(tail -n +2 temp.csv) | uniq >> temp2.csv;
    rm temp.csv;
    ${eliminate_singles}/bin/eliminate_singles temp2.csv;
    rm temp2.csv;
  '';
}
