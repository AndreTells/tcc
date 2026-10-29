let 
  nixpkgs = builtins.fetchTarball {
    url= "https://github.com/NixOS/nixpkgs/archive/3ec1b8b9034fb5c806124324b0e4bc5e50a4f13c";
    sha256 = "sha256-V3IzXbAPnKwEIjvuFx3ab9XbQwa3P18YDF3Z36sTUHg=";
  };
  pkgs = import nixpkgs {};
in 
let 
  packageOverrides = pkgs.callPackage ./python-packages.nix { };
  python = pkgs.python313.override { inherit packageOverrides; };
  pythonpkgs = python.pkgs;
in 
pythonpkgs.buildPythonPackage (finalAttrs: {
  name="clustering_pattern_miner";
  version="1.0";
  pyproject = true;
  build-system = [ pythonpkgs.setuptools ];
  dependencies = with pythonpkgs; [
    kmodes
    pandas
  ];
  src=./.;
})
