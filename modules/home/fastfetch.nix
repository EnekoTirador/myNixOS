# Fastfetch: tu config.jsonc (igual en los dos PCs) y una foto distinta por PC.
#   files/fastfetch.jsonc                → ~/.config/fastfetch/config.jsonc
#   files/fastfetch-logo-sobremesa.webp  → ~/.config/fastfetch/logo.webp (sobremesa)
#   files/fastfetch-logo-portatil.webp   → ~/.config/fastfetch/logo.webp (portátil)
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { osConfig, ... }: {
      xdg.configFile."fastfetch/config.jsonc".source = ./files/fastfetch.jsonc;

      # La foto se elige según el hostname del PC
      xdg.configFile."fastfetch/logo.webp".source =
        if osConfig.networking.hostName == "EkoPortatil"
        then ./files/fastfetch-logo-portatil.webp
        else ./files/fastfetch-logo-sobremesa.webp;
    };
  };
}
