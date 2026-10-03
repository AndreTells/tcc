let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
  glibc_functions_list = import ../list_glibc_functions/default.nix;
in 
pkgs.mkShell 
{
  name="filter_mined_data_dev_shell";
  packages = [
      pkgs.clang-tools 
      pkgs.clang 
      pkgs.lldb
      glibc_functions_list
  ];

  shellHook = ''
    export GLIBC_FUNCTIONS_LIST_PATH=${glibc_functions_list}/${glibc_functions_list.OUTPUT_FILE_NAME}
  '';
}
