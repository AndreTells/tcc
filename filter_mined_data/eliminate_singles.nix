let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
in 
pkgs.python313Packages.buildPythonApplication (finalAttrs: {
  name="single_function_caller_elimination";
  version="1.0";
  pyproject = true;
  build-system = [ pkgs.python313Packages.setuptools ];
  dependencies = with pkgs.python313Packages; [
      pandas
  ];
  src=./.;
})
