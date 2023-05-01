{
    pkgs,
}: let callPackage = pkg: pkgs.callPackage pkg;
in {
    godot-bin = callPackage ./godot-bin {};
}
