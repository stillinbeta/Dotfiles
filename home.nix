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

    ignores = [ "*" ];

    extraConfig = {
      init = { defaultBranch = "main"; };
      core = {
        excludesfile = "/home/ellie/.gitignore_global";
        editor = "emacs";
      };
      magithub = { online = false; };
    };
  };

  programs.fish = {
    enable = true;
    functions = {
      fish_mode_prompt = ''
        set -l last_status $status
                switch $fish_bind_mode
                  case default
                    set_color --bold red
                    echo '[N] '
                  case insert
                    if test $last_status -ne 0
                      set_color --bold red
                    else
                      set_color --bold green
                    end
                    string join ''' -- '[' $last_status '] '
                  case replace_one replace
                    set_color --bold green
                    echo '[R] '
                  case visual
                    set_color --bold brmagenta
                    echo '[V] '
                  case '*'
                    set_color --bold red
                    echo '[?] '
                end
      '';
      fish_prompt = ''
        string join ''' -- '% ' (set_color normal)
      '';

      fish_right_prompt = ''

        string join ''' (prompt_pwd) (fish_vcs_prompt)
      '';

    };
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };

  home.stateVersion = "24.11";

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      # enableFishIntegration = true;
    };

  # Let home Manager install and manage itself.
    home-manager.enable = true;
  };
}
