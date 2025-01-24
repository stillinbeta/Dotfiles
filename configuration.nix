# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./sway-gnome.nix
    # /home/ellie/suspend-and-hibernate.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.enable = true;

  networking.hostName = "asterius"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zonek
  time.timeZone = "America/Vancouver";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    # keyMap = "dvorak";
    #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser pkgs.cups-brother-mfcl2750dw ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.logind.lidSwitch = "suspend";

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.zsh.enable = true;

  programs.direnv.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.sane.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ellie = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "docker"
      "scanner" # (USB) scanning
      "lp" # printing
    ];
    packages = with pkgs; [
    ];
  };

  # home-manager.users.ellie = { pkgs, ... }: {
  #   home.packages = [ pkgs.atool pkgs.httpie ];
  #   programs.zsh.enable = true;

  #   # The state version is required and should stay at the version you
  #   # originally installed.
  #   home.stateVersion = "24.11";
  # };

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    bemenu
    wdisplays
    xdg-utils
    git
    gcc
    nixfmt-classic
    openssl
    pkg-config
    wireguard-tools
    kdePackages.qt6ct
    cachix
  ];

  qt.platformTheme = "gnome";

  services.xserver = {
    enable = true; # even tho this I use wayland.

    desktopManager.gnome.enable = true;

    displayManager.gdm = {
      enable = true;
      autoSuspend = true;
      wayland = true;
    };
  };

  # gnome = {
  #   core-developer-tools.enable = true;
  #   games.enable = true;
  # };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

  };

  services.dbus.enable = true;
  #  xdg.portal = {
  #    enable = true;
  #    wlr.enable = true;
  #    # gtk portal needed to make gtk apps happy
  #    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #2  };

  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
    menuentry "Ubuntu" {
      search --set=ubuntu --fs-uuid 30b66060-c0ff-4d84-a8bb-e43c6892b290
      configfile "($ubuntu)/boot/grub/grub.cfg"
    }
  '';
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.fwupd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 8000 ];
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      metric = 1001;
      ips = [ "192.168.2.4/24" ];
      listenPort = 51820;

      privateKeyFile = "/home/ellie/.config/wireguard/private";
      peers = [{
        publicKey = "o4FDF7gzOf2xrR83jHSHLIinIcMYU84prbxE/1uTLQ0=";
        allowedIPs = [ "192.168.2.0/24" "192.168.4.0/22" ];

        # requires `--impure` :(
        endpoint = (builtins.readFile /home/ellie/.config/wireguard/host);
        persistentKeepalive = 25;
      }];
    };
  };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

