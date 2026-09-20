{ self, inputs, ... }: {
  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    imports =
    [ # Include the results of the hardware scan.
      self.nixosModules.myMachineHardware
      self.nixosModules.niri
    ];
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    programs.nix-ld.enable = true;
    # Servicio para nautilus
    services.gvfs.enable = true;
    # Servicio necesario para Docker
    virtualisation.docker.enable = true;
    # Añadir SDDM para el Log-In
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
      package = pkgs.kdePackages.sddm;
    };


    environment.systemPackages = with pkgs; [
      # ------------
      # --- APPS ---
      # ------------
      # Navegador
      firefox
      # Texto
      vim
      neovim # AstroNvim
      git
      ripgrep
      fd
      unzip
      nodejs
      lazygit
      nerd-fonts.jetbrains-mono
      gcc
      # Tema de SDDM
      (catppuccin-sddm.override {
        flavor = "mocha";
        font = "JetBrainsMono Nerd Font";
        fontSize = "10";
      })
      # Gestor de archivos
      nautilus
      # Gestor de tareas
      planify
      # Automontar pendrives
      udiskie
      # Reproductor multimedia
      mpv
      # Visor de imágenes
      imv
      # Captura de pantalla
      grim
      # Selección de área
      slurp
      # Anotar capturas
      swappy
      # Mensajería
      vesktop
      # Monitor de sistema
      btop
      # Compresión de archivos
      p7zip
      # Bloqueo de pantalla
      swaylock-effects
      # Lector de PDF
      zathura
      # Suite ofimática
      libreoffice
      # Cliente torrent
      qbittorrent
      # Contenedores
      docker
      # Info del sistema
      fastfetch
      # Portapapeles Wayland
      wl-clipboard
      # Grabar pantalla
      kooha
      # Contraseñas
      # Gestor de contraseñas
      keepassxc

      # -----------------
      # --- COMMANDOS ---
      # -----------------
      # Ver files en formato tree
      tree
      # Descargar archivos
      wget
      curl
      # Visualizar archivos de programacion
      bat
    ];

    services.upower.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "EkoPortatil"; # Define your hostname.
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Madrid";

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
    };

    services.xserver.xkb = {
      layout = "es";
      variant = "";
    };

    console.keyMap = "es";

    users.users."eko" = {
      isNormalUser = true;
      description = "Eneko Tirador";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [];
    };


    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "26.05";
  };
}
