# Fastfetch: tu config.jsonc de siempre, copiada tal cual a
# modules/home/files/fastfetch.jsonc → ~/.config/fastfetch/config.jsonc
# (el logo.webp sigue en ~/.config/fastfetch y no se toca)
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { ... }: {
      xdg.configFile."fastfetch/config.jsonc".source = ./files/fastfetch.jsonc;
    };
  };
}
