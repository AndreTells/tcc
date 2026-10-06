let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  data = import ../filter_mined_data/default.nix;
in 
pkgs.mkShellNoCC{
  packages = [ pkgs.python3 ];
  shellHook = ''
    export DATA=${data}/${data.OUTPUT_FILE_NAME}
  '';
}
