# Integración de Home Manager como módulo de NixOS.
#
# Con esto NO hay que usar el comando `home-manager`: todo se aplica con el
# `sudo nixos-rebuild switch --flake ...` de siempre, y cada generación del
# sistema (las del menú de arranque) incluye también tu home.
{ inputs, ... }: {
  flake.nixosModules.home-manager = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      # Usa el mismo `pkgs` del sistema (y su allowUnfree = true)
      useGlobalPkgs = true;
      # Los home.packages se instalan en el perfil del usuario
      # (/etc/profiles/per-user/eko), sin necesitar `nix-env`
      useUserPackages = true;
      # Si Home Manager va a crear un archivo que YA existe en tu home,
      # en vez de fallar lo renombra a <archivo>.hm-backup
      backupFileExtension = "hm-backup";
    };
  };
}
