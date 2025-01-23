{ config, pkgs, ... }:

{
  home.username = "ellie";
  home.homeDirectory = "/home/ellie";

  home.packages = with pkgs; [
      # gui apps
      kicad
      firefox
      calibre
      emacs29-pgtk
      inconsolata
      libreoffice
      simple-scan
      gimp
      wireshark
      (inkscape-with-extensions.override ({
        inkscapeExtensions = [ inkscape-extensions.applytransforms ];
      }))
      pavucontrol
      vlc
      openscad
      blender
      zeal-qt6

      # dev tools
      ripgrep
      direnv
      python3

      # cli utils
      jq
      tree
      htop
      file
      ispell
      dig
      mtr
      zip
      unzip
      conda

      # gnome extensions
      gnomeExtensions.caffeine
      gnomeExtensions.pop-shell
  ];

  programs.git = {
    enable = true;
    userName = "Ellie Frost";
    userEmail = "web@stillinbeta.com";

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        excludesfile = "/home/ellie/.gitignore_global";
        editor = "emacs";
      };
      magithub = {
        online = false;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
  };

  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
