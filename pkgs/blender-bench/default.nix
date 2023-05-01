{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  name = "blender-bench";
  version = "3.5";
  src = pkgs.fetchzip {
    url = "https://download.blender.org/release/BlenderBenchmark2.0/launcher/benchmark-launcher-3.1.0-linux.tar.gz";
    sha256 = "af9RJeIdtOsCdc6r58BsRKomW1j5wa999BunAfcE2dg=";
  };
  nativeBuildInputs = with pkgs;
    [
      autoPatchelfHook
    ]
    ++ runtimeDependencies;
  #sourceRoot = ".";
  runtimeDependencies = with pkgs; [
    libGL
    libglvnd
    libstdcxx5
    xorg.libXxf86vm
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
    stdenv.cc.cc.lib
  ];
  dontStrip = true;
  preFixup = let
    libPath = with pkgs;
      lib.makeLibraryPath [
        libGL
        libglvnd
        libstdcxx5
        xorg.libXxf86vm
        xorg.libX11
        xorg.libXcursor
        xorg.libXinerama
        xorg.libXext
        xorg.libXrandr
        xorg.libXrender
        xorg.libXi
        xorg.libXfixes
        stdenv.cc.cc.lib
      ];
  in ''
      patchelf \
    --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    --set-rpath "${libPath}" \
    $out/bin/benchmark-launcher
  '';
  buildPhase = ''
    ls -lah
  '';
  installPhase = ''
    install -m755 -D benchmark-launcher $out/bin/benchmark-launcher
  '';
}
