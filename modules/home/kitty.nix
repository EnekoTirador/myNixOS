# Kitty gestionado por Home Manager (antes: repo github.com/EnekoTirador/Kitty
# clonado en ~/.config/kitty). Genera ~/.config/kitty/kitty.conf.
#
# Este archivo AÑADE cosas al módulo home-eko (no hace falta importarlo en los
# hosts): flake-parts junta todas las definiciones de nixosModules.home-eko.
{ ... }: {
  flake.nixosModules.home-eko = { ... }: {
    home-manager.users.eko = { pkgs, ... }: {
      programs.kitty = {
        enable = true;

        font = {
          name = "JetBrainsMono Nerd Font";
          size = 12;
        };

        settings = {
          shell = "zsh";

          # Ventana
          window_padding_width = 14;
          background_opacity = "0.85";
          confirm_os_window_close = 0;
          active_border_color = "#ffffff";
          inactive_border_color = "#2a2a2a";
          hide_window_decorations = "yes";
          enable_audio_bell = "no";
          dynamic_background_opacity = "yes";

          # Cursor
          cursor_shape = "beam";
          cursor_beam_thickness = "1.5";

          # Tema monocromo (blanco y negro)
          foreground = "#E6E6E6";
          background = "#1c1c1c";
          selection_foreground = "#000000";
          selection_background = "#E6E6E6";
          cursor = "#FFFFFF";
          cursor_text_color = "#000000";
          url_color = "#FFFFFF";

          # Colores ANSI en escala de grises
          color0 = "#262626";
          color1 = "#6E6E6E";
          color2 = "#8C8C8C";
          color3 = "#A8A8A8";
          color4 = "#7A7A7A";
          color5 = "#969696";
          color6 = "#B4B4B4";
          color7 = "#D0D0D0";
          color8 = "#404040";
          color9 = "#8A8A8A";
          color10 = "#A6A6A6";
          color11 = "#C2C2C2";
          color12 = "#999999";
          color13 = "#B0B0B0";
          color14 = "#CCCCCC";
          color15 = "#FFFFFF";

          # Barra de pestañas
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_bar_background = "#000000";
          active_tab_foreground = "#000000";
          active_tab_background = "#FFFFFF";
          active_tab_font_style = "bold";
          inactive_tab_foreground = "#8C8C8C";
          inactive_tab_background = "#1A1A1A";
          inactive_tab_font_style = "normal";
        };

        keybindings = {
          # Shift+F9 → opacidad al 100%; F9 → opacidad por defecto
          "shift+f9" = "set_background_opacity 1";
          "f9" = "set_background_opacity default";
        };
      };
    };
  };
}
