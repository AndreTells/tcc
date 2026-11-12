let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  base = ./base.csv;
  function_extractor = import ./function_extractor.nix;
  binPath = pkgs.lib.makeBinPath [ pkgs.coreutils];
in 
pkgs.writeTextFile
{
  name="call_graph_miner";
  executable=true;
  text = ''
    #!${pkgs.runtimeShell}
    export PATH="${binPath}:$PATH"

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
            in_file="$2";
            shift;
          else 
            echo "input is a file not directory";
            exit 1;
          fi
          ;;
        *)
          break
        ;;
      esac
      shift
    done

    if [[ -z $in_file ]]; then 
      echo "no input folder";
      exit 1;
    fi 

    if [[ -n "$out_file" ]]; then
      cat ${base} >> $out_file
      command="rg '#if' '{}' --files-without-match -q && ${function_extractor} '{}' $in_file >> $out_file; echo 'done {}'"
    else 
      cat ${base}
      command="rg '#if' '{}' --files-without-match -q && ${function_extractor} '{}' $in_file"
    fi

    find -L $in_file -name '*.c' | xargs -P 100 -I {} sh -c "$command"
  '';

}
