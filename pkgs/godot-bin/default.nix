{pkgs,stdenv,...}:
stdenv.mkDerivation rec {
  name = "godot";
  version = "4.0-stable";
  src = pkgs.fetchzip {
    url = "https://github.com/godotengine/godot/releases/download/4.0-stable/Godot_v4.0-stable_linux.x86_64.zip";
    sha256 = "FRvQCBTJMES/488a5jfcj/e5tYLWD3ygmfTEcMXkD2U=";
  };
  nativeBuildInputs = [pkgs.autoPatchelfHook];
  #sourceRoot = ".";
  runtimeDependencies = with pkgs; [
    vulkan-loader
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libXi
    xorg.libXfixes
    libxkbcommon
    alsa-lib
    libpulseaudio
    dbus
    dbus.lib
    speechd
    fontconfig
    fontconfig.lib
    udev
  ];
  dontStrip = true;
  preFixup = let
    libPath = with pkgs;
      lib.makeLibraryPath [
        stdenv.cc.cc.lib
        xorg.libX11
      ];
  in ''
      patchelf \
    --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    --set-rpath "${libPath}" \
    $out/bin/godot
  '';
  buildPhase = ''
    ls -lah
  '';
  installPhase = ''
    install -m755 -D Godot_v4.0-stable_linux.x86_64 $out/bin/godot
  '';
}
