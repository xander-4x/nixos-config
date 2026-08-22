{ pkgs, ... }: {
  home.packages = [
    pkgs.go
    pkgs.gcc
  ];
}

