#!/bin/sh
REPO_LIST_FILE_NAME="test.nix";
REPO_URL_LIST="few_repos.txt";

rm -f $REPO_LIST_FILE_NAME

echo "{pkgs? import<nixpkgs>{}}:
with pkgs; [" >> $REPO_LIST_FILE_NAME;

cat $REPO_URL_LIST | xargs  -I {} sh -c "cat <(echo '(' ) <(nurl {} ) <(echo ')') >> $REPO_LIST_FILE_NAME";

echo "]" >> $REPO_LIST_FILE_NAME;
