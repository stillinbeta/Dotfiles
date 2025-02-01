{ config, pkgs, ... }:

{
  home.username = "ellie";
  home.homeDirectory = "/home/ellie";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # gui apps
    kicad
    calibre
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

  home.file.".emacs.d" = {
    # don't make the directory read only so that impure melpa can still happen
    # for now
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "syl20bnr";
      repo = "spacemacs";
      rev = "f036abf4c72b2af441a6aa3afda72f47c322fb95";
      sha256 = "sha256-Rb1HM1lDUQWef5KnvPCEBuBwvDDLruJfG4rhFzJ+pVU=";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Ellie Frost";
      userEmail = "web@stillinbeta.com";

      extraConfig = {
        init = { defaultBranch = "main"; };
        core = {
          excludesfile = "/home/ellie/.gitignore_global";
          editor = "emacs";
        };
        magithub = { online = false; };
      };
    };

    # apparently fish is a bad default shell
    bash = {
      enable = true;
      initExtra = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    fish = {
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


    emacs = {
      enable = true;
      package = pkgs.emacs29-pgtk;
    };

    firefox = { enable = true; };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      # enableFishIntegration = true;
    };

    # Let home Manager install and manage itself.
    home-manager.enable = true;
  };
}
