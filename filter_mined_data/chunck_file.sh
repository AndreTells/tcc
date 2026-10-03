mkdir chuncks;
cd chuncks;
split -l 2 <(tail -n +2 ../$1);
ls | xargs -I {} ../add_header.sh ../$1 {};
