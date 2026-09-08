let 
  pkgs = import <nixpkgs> {};
in 
pkgs.clangStdenv.mkDerivation {
  name="tcc-dev-environment";
  buildInputs = with pkgs; [
    llvmPackages_21.libclang
    clang-tools
  ];

}
