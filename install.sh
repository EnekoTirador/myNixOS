#!/usr/bin/env bash
# Instalador interactivo de la config NixOS de eko en un PC nuevo.
# Uso:  bash install.sh [--no-build] [--no-dotfiles] [-h]
set -uo pipefail

R=$'\e[31m'; G=$'\e[32m'; Y=$'\e[33m'; B=$'\e[34m'; N=$'\e[0m'
info(){ echo "${B}==>${N} $*"; }
ok(){   echo "${G} ✔${N} $*"; }
warn(){ echo "${Y} !${N} $*"; }
die(){  echo "${R} ✘ $*${N}" >&2; exit 1; }
ask(){  # ask "pregunta" "defecto" -> REPLY_V
  local d="${2:-}" a
  read -r -p "$1${d:+ [$d]}: " a || a=""
  REPLY_V="${a:-$d}"
}
confirm(){ # confirm "pregunta" s|n
  local d="${2:-s}" a
  read -r -p "$1 [$( [ "$d" = s ] && echo S/n || echo s/N )]: " a || a=""
  a="${a:-$d}"; [[ "$a" =~ ^[sSyY] ]]
}
camel(){ echo "$1" | sed -E 's/-([a-z0-9])/\U\1/g'; }

DO_BUILD=1; DO_DOTS=1
for a in "$@"; do case "$a" in
  --no-build) DO_BUILD=0;; --no-dotfiles) DO_DOTS=0;;
  -h|--help) sed -n '2,3p' "$0"; exit 0;;
  *) die "Opción desconocida: $a";; esac; done

TEST="${INSTALL_TEST:-}"

# ---------- comprobaciones ----------
[ "$(id -u)" -ne 0 ] || [ -n "$TEST" ] || die "No lo ejecutes como root; usa tu usuario (pedirá sudo cuando haga falta)."
if [ -z "$TEST" ]; then
  [ -e /etc/NIXOS ] || die "Esto no es NixOS."
fi
if ! command -v git >/dev/null 2>&1; then
  [ -z "${INSTALL_REEXEC:-}" ] || die "No se pudo obtener git."
  info "Falta git, reabriendo el script dentro de nix-shell -p git..."
  INSTALL_REEXEC=1 exec nix-shell -p git --run "bash '$0' $*"
fi

# ---------- git ----------
setup_git(){
  info "Configuración de git"
  local n e
  n="$(git config --global user.name || true)"; e="$(git config --global user.email || true)"
  if [ -z "$n" ]; then ask "Nombre para los commits" "Eneko Tirador"; git config --global user.name "$REPLY_V"; fi
  if [ -z "$e" ]; then ask "Email para los commits" ""; [ -n "$REPLY_V" ] && git config --global user.email "$REPLY_V"; fi
  if ! git config --global credential.helper >/dev/null; then
    echo "  Para hacer push a GitHub necesitas un token (guardado en KeePassXC)."
    echo "  1) cache (lo recuerda 8h en memoria, más seguro)"
    echo "  2) store (lo guarda en texto plano en ~/.git-credentials)"
    echo "  3) ninguno"
    ask "Opción" "1"
    case "$REPLY_V" in
      1) git config --global credential.helper 'cache --timeout=28800';;
      2) git config --global credential.helper store;;
    esac
  fi
  ok "git listo"
}

# ---------- repo ----------
locate_repo(){
  local here; here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "$here/flake.nix" ]; then REPO="$here"
  elif [ -f "$HOME/myNixOS/flake.nix" ]; then REPO="$HOME/myNixOS"
  else
    ask "URL del repo de GitHub a clonar (https://github.com/usuario/repo)" ""
    [ -n "$REPLY_V" ] || die "Necesito un repo."
    git clone "$REPLY_V" "$HOME/myNixOS" || die "Falló el clonado (¿token/URL?)."
    REPO="$HOME/myNixOS"
  fi
  [ -d "$REPO/modules" ] || die "$REPO no parece la config (falta modules/)."
  cd "$REPO" || die "No puedo entrar a $REPO"
  git rev-parse --git-dir >/dev/null 2>&1 || die "$REPO no es un repo git (los flakes necesitan git)."
  ok "Repo: $REPO"
}

# ---------- host nuevo ----------
create_host(){
  info "Nuevo host"
  while :; do
    ask "ID del host (minúsculas/guiones, ej: sobremesa)" ""
    [[ "$REPLY_V" =~ ^[a-z][a-z0-9-]*$ ]] && break
    warn "ID inválido."
  done
  HOST="$REPLY_V"; CAMEL="$(camel "$HOST")"; HDIR="modules/hosts/$HOST"
  if [ -d "$HDIR" ]; then
    confirm "$HDIR ya existe. ¿Reutilizarlo sin regenerar?" s && { ok "Se reutiliza $HDIR"; return; }
    confirm "¿Sobrescribir?" n || die "Cancelado."
  fi
  ask "Hostname de la máquina" "Eko$(echo "${HOST:0:1}" | tr a-z A-Z)${HOST:1}"; HNAME="$REPLY_V"

  SV="26.05"
  if [ -r /etc/nixos/configuration.nix ]; then
    d="$(grep -oP 'stateVersion\s*=\s*"\K[^"]+' /etc/nixos/configuration.nix | head -1 || true)"
    [ -n "$d" ] && SV="$d"
  fi
  ask "system.stateVersion (¡el de la instalación, no lo cambies luego!)" "$SV"; SV="$REPLY_V"

  GPU="$(lspci 2>/dev/null | grep -iE 'vga|3d' || true)"
  [ -n "$GPU" ] && echo "  GPU detectada: $GPU"
  NV=n; echo "$GPU" | grep -qi nvidia && NV=s
  USE_NV=0; confirm "¿Usar driver Nvidia (módulo hardware-nvidia)?" "$NV" && USE_NV=1
  USE_GAME=0; confirm "¿Instalar módulo de gaming (Steam, gamemode, gamescope)?" n && USE_GAME=1

  # discos extra
  DISKS=""
  if [ -z "$TEST" ] && command -v lsblk >/dev/null && confirm "¿Montar discos extra (ej: disco de juegos)?" n; then
    lsblk -f
    while :; do
      ask "UUID del disco (vacío para terminar)" ""
      [ -z "$REPLY_V" ] && break
      u="$REPLY_V"; ask "Tipo de sistema de ficheros" "btrfs"; t="$REPLY_V"
      ask "Punto de montaje" "/mnt/juegos"; m="$REPLY_V"
      DISKS+="    fileSystems.\"$m\" = { device = \"/dev/disk/by-uuid/$u\"; fsType = \"$t\"; options = [ \"nofail\" ]; };"$'\n'
    done
  fi

  mkdir -p "$HDIR"

  # default.nix
  cat > "$HDIR/default.nix" <<NIX
{ self, inputs, ... }: {
  flake.nixosConfigurations.$HOST = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.${CAMEL}Configuration ];
  };
}
NIX

  # hardware.nix (envuelto como módulo flake-parts)
  if [ -n "$TEST" ]; then
    HW='{ config, lib, pkgs, modulesPath, ... }: { }'
  else
    HW="$(nixos-generate-config --show-hardware-config)" || die "nixos-generate-config falló."
  fi
  { echo "{ ... }: {"; echo "  flake.nixosModules.${CAMEL}Hardware ="; echo "$HW"; echo "  ;"; echo "}"; } > "$HDIR/hardware.nix"

  # configuration.nix
  local nv="" game=""
  [ $USE_NV = 1 ]   && nv="      self.nixosModules.hardware-nvidia"$'\n'
  [ $USE_GAME = 1 ] && game="      self.nixosModules.apps-gaming"$'\n'
  cat > "$HDIR/configuration.nix" <<NIX
{ self, ... }: {
  flake.nixosModules.${CAMEL}Configuration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.${CAMEL}Hardware
${nv}      self.nixosModules.core-nix
      self.nixosModules.core-boot
      self.nixosModules.core-locale
      self.nixosModules.core-network
      self.nixosModules.niri
      self.nixosModules.desktop-sddm
      self.nixosModules.desktop-theming
      self.nixosModules.desktop-filesystems
      self.nixosModules.service-docker
      self.nixosModules.user-eko
      self.nixosModules.apps-browsers
      self.nixosModules.apps-terminal
      self.nixosModules.apps-dev
      self.nixosModules.apps-media
      self.nixosModules.apps-productivity
      self.nixosModules.apps-communication
      self.nixosModules.apps-network
      self.nixosModules.apps-system-tools
      self.nixosModules.apps-cli-tools
${game}    ];

    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
    networking.hostName = "$HNAME";
    system.stateVersion = "$SV";
${DISKS}  };
}
NIX

  # no subir el resultado de builds
  grep -qxF result .gitignore 2>/dev/null || echo result >> .gitignore
  git add -A
  ok "Host '$HOST' creado en $HDIR y añadido a git"
  warn "modules/desktop/niri.nix tiene los monitores de 'sobremesa' (HDMI-A-1, DP-2, DP-3). Revisa con 'niri msg outputs' si tu PC es distinto."
}

# ---------- build ----------
build_and_apply(){
  [ $DO_BUILD = 1 ] || { warn "Se omite el build (--no-build)."; return; }
  [ -z "$TEST" ] || { info "(test) se omite nixos-rebuild"; return; }
  info "Comprobando la config (build, sin activar)..."
  sudo nixos-rebuild build --flake ".#$HOST" || die "El build falló. Corrige el error y vuelve a ejecutar (reutiliza el host existente)."
  ok "Build correcto"
  echo "  1) boot   (se activa al reiniciar, lo más seguro)"
  echo "  2) switch (se activa ya)"
  echo "  3) nada"
  ask "Opción" "1"
  case "$REPLY_V" in
    1) sudo nixos-rebuild boot   --flake ".#$HOST" && NEED_REBOOT=1;;
    2) sudo nixos-rebuild switch --flake ".#$HOST";;
  esac
}

# ---------- repos de GitHub (kitty y vim) ----------
KITTY_REPO="https://github.com/EnekoTirador/Kitty"
VIM_REPO="https://github.com/EnekoTirador/Vim"
REPOS_CLONED=0

clone_repo(){ # clone_repo URL DESTINO
  local url="$1" dest="$2"
  if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --ff-only -q && ok "$dest actualizado" || warn "No pude actualizar $dest"
  else
    if [ -e "$dest" ]; then
      mv "$dest" "$dest.bak.$(date +%s)"
      warn "Había algo en $dest; lo moví a $dest.bak.*"
    fi
    mkdir -p "$(dirname "$dest")"
    git clone -q "$url" "$dest" && ok "$dest clonado" || { warn "Falló el clonado de $url"; return 1; }
  fi
}
clone_repos(){
  [ $DO_DOTS = 1 ] || return 0
  confirm "¿Clonar tus repos de Kitty y Vim desde GitHub?" s || return 0
  local k=0 v=0
  clone_repo "$KITTY_REPO" "$HOME/.config/kitty" && k=1
  clone_repo "$VIM_REPO"   "$HOME/.vim"          && v=1
  [ $k = 1 ] && [ $v = 1 ] && REPOS_CLONED=1
  # Si el repo de vim trae un .vimrc en la raíz, vim lo necesita en ~/.vimrc
  if [ $v = 1 ] && [ -f "$HOME/.vim/.vimrc" ]; then
    [ -e "$HOME/.vimrc" ] && [ ! -L "$HOME/.vimrc" ] && mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
    ln -sf "$HOME/.vim/.vimrc" "$HOME/.vimrc" && ok "~/.vimrc -> ~/.vim/.vimrc"
  fi
  [ $k = 1 ] && KITTY_DONE=1 || KITTY_DONE=0
  [ $v = 1 ] && VIM_DONE=1 || VIM_DONE=0
}
KITTY_DONE=0; VIM_DONE=0

# ---------- dotfiles (resto: swaylock, fastfetch, yazi, capturas) ----------
cp_safe(){ # cp_safe origen destino
  [ -e "$1" ] || { warn "No existe $1 (¿subiste dotfiles/ al repo?)"; return; }
  mkdir -p "$(dirname "$2")"
  [ -e "$2" ] && [ ! -L "$2" ] && cp -a "$2" "$2.bak"
  cp -a "$1" "$2"; ok "$2"
}
screenshot_script(){
  local dst="$HOME/.local/bin/screenshot-clipboard.sh"
  mkdir -p "$HOME/.local/bin" "$HOME/Pictures/Screenshots"
  if [ -f dotfiles/bin/screenshot-clipboard.sh ]; then
    cp_safe dotfiles/bin/screenshot-clipboard.sh "$dst"
  elif [ ! -e "$dst" ]; then
    cat > "$dst" <<'SH'
#!/usr/bin/env bash
# Captura de una zona: copia al portapapeles y guarda en Pictures/Screenshots
f="$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"
area="$(slurp)" || exit 0
grim -g "$area" - | tee "$f" | wl-copy
SH
    ok "$dst creado (versión mínima)"
  fi
  chmod +x "$dst" 2>/dev/null || true
}
install_dotfiles(){
  [ $DO_DOTS = 1 ] || return 0
  confirm "¿Instalar el resto de dotfiles (swaylock, fastfetch, yazi, script de capturas)?" s || { install_vim_plugins; return 0; }
  info "Copiando dotfiles (backup .bak si ya existían)"
  if [ -d dotfiles ]; then
    # kitty y vim solo si no se clonaron de GitHub
    [ $KITTY_DONE = 1 ] || cp_safe dotfiles/kitty/kitty.conf "$HOME/.config/kitty/kitty.conf"
    cp_safe dotfiles/swaylock/config        "$HOME/.config/swaylock/config"
    cp_safe dotfiles/fastfetch/config.jsonc "$HOME/.config/fastfetch/config.jsonc"
    cp_safe dotfiles/yazi/keymap.toml       "$HOME/.config/yazi/keymap.toml"
    if [ $VIM_DONE = 0 ]; then
      cp_safe dotfiles/vim/.vimrc "$HOME/.vimrc"
      [ -d dotfiles/vim/.vim ] && { mkdir -p "$HOME/.vim"; cp -a dotfiles/vim/.vim/. "$HOME/.vim/"; ok "$HOME/.vim"; }
    fi
  else
    warn "No hay carpeta dotfiles/ en el repo; solo se hace lo de kitty/vim por GitHub y el script de capturas."
  fi
  screenshot_script
  install_vim_plugins
}
install_vim_plugins(){
  [ -f "$HOME/.vim/plugins.vim" ] || [ -f "$HOME/.vimrc" ] || return 0
  command -v vim >/dev/null || { warn "vim aún no está instalado (aparecerá tras reiniciar/switch). Luego ejecuta: vim +PlugInstall +qall"; return; }
  grep -rqs 'plug#begin' "$HOME/.vim" "$HOME/.vimrc" 2>/dev/null || return 0
  confirm "¿Instalar plugins de vim (vim-plug + PlugInstall)?" s || return 0
  local pl="$HOME/.vim/autoload/plug.vim"
  if [ ! -f "$pl" ]; then
    curl -fsSLo "$pl" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
      || { warn "No se pudo bajar vim-plug."; return; }
  fi
  vim -es -i NONE -c PlugInstall -c qa </dev/null >/dev/null 2>&1 || true
  ok "Plugins de vim procesados"
}

# ---------- commit / push ----------
publish(){
  git diff --cached --quiet && return 0
  confirm "¿Hacer commit del nuevo host?" s || return 0
  git commit -m "Añadir host $HOST" -q && ok "Commit hecho"
  if [ -z "$TEST" ] && git remote | grep -q . && confirm "¿Push a GitHub?" n; then
    git push || warn "Push falló (revisa el token)."
  fi
}

# ---------- main ----------
NEED_REBOOT=0
echo "${B}Instalador de la config NixOS de eko${N}"
setup_git
locate_repo
create_host
build_and_apply
clone_repos
install_dotfiles
publish

echo
ok "Terminado."
cat <<MSG
Recuerda manualmente:
  • Iconos/apps: si alguna falta (ej. OBS), revisa el .desktop.
  • Monitores: ajusta 'outputs' en modules/desktop/niri.nix si no coinciden.
  • Steam: añade tu disco de juegos desde Steam > Ajustes > Almacenamiento.
  • Token de GitHub: está en KeePassXC.
  • Siguientes cambios:  sudo nixos-rebuild switch --flake ~/myNixOS#$HOST
MSG
if [ "$NEED_REBOOT" = 1 ] && [ -z "$TEST" ] && confirm "¿Reiniciar ahora?" n; then sudo reboot; fi
