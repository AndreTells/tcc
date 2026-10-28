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
  name="glibc_functions_list";
  executable=true;
  text = ''
    #!${pkgs.runtimeShell}
    export PATH="${binPath}:$PATH"
    rm out.csv
    touch out.csv
    chmod a+w out.csv
    cat ${base} >> out.csv
    find -L $1 -name '*.c' | xargs -P 100 -I {} sh -c "${function_extractor} {} $1 >> out.csv; echo 'done {}'"
  '';

}
