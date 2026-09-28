let 
  pkgs = import <nixpkgs> {};
  REPO_LIST_FILE_NAME="out.nix"; 
in 
pkgs.writeShellApplication {
  name = "create-repo_list-0.1";
  
  # Dependencies available to the script at runtime
  runtimeInputs = with pkgs; [ 
    nurl 
  ]; 

  text = ''
    if [ -z "$1" ]
      then
        echo "no repo list"
    fi

    rm -f ${REPO_LIST_FILE_NAME}

    echo "{pkgs? import<nixpkgs>{}}:
    with pkgs; [" >> ${REPO_LIST_FILE_NAME};

    cat "$1" | xargs  -I {} sh -c "cat <(echo '(' ) <(nurl {} ) <(echo ')') >> ${REPO_LIST_FILE_NAME}";

    echo "]" >> ${REPO_LIST_FILE_NAME};
  '';
}
