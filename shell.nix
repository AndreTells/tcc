let 
  pkgs = import <nixpkgs> {};
in 
pkgs.clangStdenv.mkDerivation {
  name="tcc-dev-environment";
  buildInputs = with pkgs; [
    llvmPackages_21.libclang
    lldb
  ];
  shellHook=''
    export CPATH=\
    ${pkgs.llvmPackages_21.libcxx.dev}/include/c++/v1:\
    ${pkgs.llvmPackages_21.libclang.dev}/include:\
    ${pkgs.clangStdenv.cc.libc.dev}/include
  '';
}
