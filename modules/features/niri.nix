{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
            spawn-at-startup = [
    	            (lib.getExe self'.packages.myNoctalia)
	      ];

	      input = {
	            keyboard = {
                        xkb.layout = "es";
                  };
                  touchpad = {
                        tap = [];
                        natural-scroll = [];
                        click-method = "clickfinger";
                  };
	      };

	      layout.gaps = 5;
	    
	      binds = {
	            "Mod+S".spawn-sh =
	                  "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
	            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
	            "Mod+Q".close-window = [];
	            "Mod+F".maximize-column = [];
                  "Mod+G".fullscreen-window = [];
                  "Mod+Shift+F".toggle-window-floating = [];
                  "Mod+C".center-column = [];
	            "Mod+O".toggle-overview = [];

                  "Mod+H".focus-column-left = [];
                  "Mod+L".focus-column-right = [];
                  "Mod+K".focus-window-up = [];
                  "Mod+J".focus-window-down = [];

                  "Mod+Left".focus-column-left = [];
                  "Mod+Right".focus-column-right = [];
                  "Mod+Up".focus-window-up = [];
                  "Mod+Down".focus-window-down = [];

                  "Mod+Shift+H".move-column-left = [];
                  "Mod+Shift+L".move-column-right = [];
                  "Mod+Shift+K".move-window-up = [];
                  "Mod+Shift+J".move-window-down = [];

                  "Mod+1".focus-workspace = 1;
                  "Mod+2".focus-workspace = 2;
                  "Mod+3".focus-workspace = 3;
                  "Mod+4".focus-workspace = 4;
                  "Mod+5".focus-workspace = 5;
                  "Mod+6".focus-workspace = 6;
                  "Mod+7".focus-workspace = 7;
                  "Mod+8".focus-workspace = 8;
                  "Mod+9".focus-workspace = 9;
                  "Mod+0".focus-workspace = 10;

                  "Mod+Shift+1".move-column-to-workspace = 1;
                  "Mod+Shift+2".move-column-to-workspace = 2;
                  "Mod+Shift+3".move-column-to-workspace = 3;
                  "Mod+Shift+4".move-column-to-workspace = 4;
                  "Mod+Shift+5".move-column-to-workspace = 5;
                  "Mod+Shift+6".move-column-to-workspace = 6;
                  "Mod+Shift+7".move-column-to-workspace = 7;
                  "Mod+Shift+8".move-column-to-workspace = 8;
                  "Mod+Shift+9".move-column-to-workspace = 9;
                  "Mod+Shift+0".move-column-to-workspace = 10;

	            "Mod+Ctrl+H".set-column-width = "-5%";
                  "Mod+Ctrl+L".set-column-width = "+5%";
                  "Mod+Ctrl+J".set-window-height = "-5%";
                  "Mod+Ctrl+K".set-window-height = "+5%";

                  "Mod+WheelScrollDown".focus-column-left = [];
                  "Mod+WheelScrollUp".focus-column-right = [];
                  "Mod+Ctrl+WheelScrollDown".focus-workspace-down = [];
                  "Mod+Ctrl+WheelScrollUp".focus-workspace-up = [];

	            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
                  "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

                  # Captura de pantalla completa
                  "Print".spawn-sh = "grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
                  # Captura de un área seleccionada
                  "Shift+Print".spawn-sh = "/home/eko/.local/bin/screenshot-clipboard.sh";
                  # Captura de área + anotar con swappy
                  "Ctrl+Print".spawn-sh = "grim -g \"$(slurp)\" - | swappy -f -";

                  "Mod+X".spawn-sh = "swaylock";
	      };
      };
    };
  };
}
