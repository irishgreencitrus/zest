{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.11.0-dev";
  src = pkgs.fetchFromGitHub {
    owner = "ziglang";
    repo = "zig";
    rev = "653814f76ba5d678ebad91f140417cd5829c6aad";
    sha256 = "SY/UzDbTcpoSBLsBPRWfn37vsjq/0uWMe9jkL0XMKCk=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    llvmPackages.llvm.dev
  ];

  buildInputs = with pkgs;
    [
      coreutils
      libxml2
      zlib
    ]
    ++ (with llvmPackages; [
      libclang
      lld
      llvm
    ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  # Zig's build looks at /usr/bin/env to find dynamic linking info. This
  # doesn't work in Nix' sandbox. Use env from our coreutils instead.
  postPatch = ''
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig --replace "/usr/bin/env" "${pkgs.coreutils}/bin/env"
  '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # ensure determinism in the compiler build
    "-DZIG_TARGET_MCPU=baseline"
  ];

  doCheck = true;
  installCheckPhase = ''
    $out/bin/zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
  '';
}
