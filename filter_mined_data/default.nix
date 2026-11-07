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
  CHUNCK_SIZE = "1000";
in 
pkgs.writeTextFile {
  name="filter_mined_data";
  version="1.0";
  executable=true;

  text = ''
    #!${pkgs.runtimeShell}
    export PATH="${binPath}:$PATH";
    export GLIBC_FUNCTIONS_LIST_PATH=${glibc_functions_list};

    in_file=
    out_file=
    while :; do
      case $1 in 
        -o) 
          if [[ -f $2 ]]; then
            echo "file already exists";
            exit 1;
          elif [[ -n $2 ]]; then 
            out_file="$2";
            shift;
          else 
            echo "no output file specified";
            exit 1;
          fi
          ;;
        -i)
          if [[ -d $2 ]]; then
            echo "input file is a directory not a file";
            exit 1;
          elif [[ -f $2 ]]; then
            in_file=$(readlink -f $2);
            shift;
          else 
            echo "no input file specified";
            exit 1;
          fi
          ;;
        *)
          break
        ;;
      esac
      shift
    done

    chuncks_folder=$(mktemp -d)
    cd $chuncks_folder;

    split -l ${CHUNCK_SIZE} <(tail -n +2 $in_file);

    if [[ -n $out_file ]]; then
      echo 'finished split';
      format_cmd="cat <(head $in_file -n 1) <(cat {}) > {}.csv; rm {}; echo 'formatted {}'"
    else 
      format_cmd="cat <(head $in_file -n 1) <(cat {}) > {}.csv; rm {}"
    fi

    ls | xargs -P 100 -I {} sh -c "$format_cmd";

    temp1=$(mktemp)
    head $in_file -n 1 >> $temp1;

    if [[ -n $out_file ]]; then
      filter_cmd="${glibc_filter} $chuncks_folder/{}  >> $temp1; echo 'done {}'"
    else 
      filter_cmd="${glibc_filter} $chuncks_folder/{}  >> $temp1"
    fi

    ls $chuncks_folder | xargs -P 100 -I {} sh -c "$filter_cmd"
    cd - > /dev/null
    rm $chuncks_folder -r;
    temp2=$(mktemp)
    head $temp1 -n 1 >> $temp2;
    sort <(tail -n +2 $temp1) | uniq >> $temp2;
    rm $temp1 

    if [[ -n $out_file ]]; then
      ${eliminate_singles}/bin/eliminate_singles $temp2 $out_file;
    else 
      temp3=$(mktemp);
      ${eliminate_singles}/bin/eliminate_singles $temp2 $temp3;
      cat $temp3;
      rm $temp3;
    fi

    rm $temp2;
  '';
}
