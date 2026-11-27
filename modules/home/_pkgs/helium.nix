{ appimageTools, fetchurl }:

let
  pname = "helium";
  version = "0.20.1.1";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-1LeJsl0KmuEsdmceRE6Khe3Pgo4EGcZ40YxB+xrDAw4=";
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${contents}/*.desktop $out/share/applications/ || true
    sed -i 's|^Exec=[^ ]*|Exec=helium|' $out/share/applications/*.desktop || true
    cp -r ${contents}/usr/share/icons $out/share/ 2>/dev/null || true
  '';
}
