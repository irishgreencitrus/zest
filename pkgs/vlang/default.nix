{pkgs ? import <nixpkgs> {}}: let
  version = "1a48d08d7ad75811458097a71d3e6e792fbc3abf";
in
  pkgs.stdenv.mkDerivation rec {
    pname = "vlang";
    inherit version;
    srcs = [
      (pkgs.fetchFromGitHub {
        owner = "vlang";
        repo = "v";
        name = "v";
        rev = version;
        sha256 = "C9b28A8YKezXawZkbF4B0yIC4NpRgibh1UD7zrfQHk0=";
      })
      (pkgs.fetchFromGitHub {
        owner = "vlang";
        repo = "vc";
        name = "vc";
        rev = "58265d75d9def5151fa6e838485a13fdc2978b14";
        sha256 = "xaUHQA+8lvO93Rwj2Y3IN92OjnVO/PCPbllI8fwVqiw=";
      })
    ];
    buildInputs = with pkgs; [
      gcc
      clang
      git
      gnumake
      libexecinfo
    ];
    nativeBuildInputs = with pkgs; [makeWrapper];
    sourceRoot = "v";
    configurePhase = ''
      export HOME="$TMP"
      chmod -R u+w ../vc
      ln -s ../vc .
    '';
    buildPhase = ''
      cc -std=gnu11 --verbose -w -o v1 vc/v.c -lm -lexecinfo -lpthread
      ./v1 -no-parallel -o v2 cmd/v
      ./v2 -o v cmd/v
      rm v1 v2
    '';
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  }
