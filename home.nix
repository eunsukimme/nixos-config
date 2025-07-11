{ config, sources ? import ./nix/sources.nix, pkgs ? import sources.nixpkgs {}, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eunsukimme";
  home.homeDirectory = "/Users/eunsukimme";
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.


  home.packages = with pkgs; [
    # dev
    docker docker-compose 
    terraform
    awscli2
    coreutils
    jq

    # utils
    iterm2
    slack
    zoom-us
    karabiner-elements
    raycast
    discord
    monitorcontrol

    # other deps
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "eunsukimme";
    userEmail = "eunsu.dev@gmail.com";
    aliases = {
      st = "status";
    };
    extraConfig = {
      core = {
        editor = "cursor -w";
      };
    };
  };
  
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "fasd" ];
    };
    shellAliases = {
      cat = "bat";
    };
    initExtra = ''
    export PATH=/opt/homebrew/bin:$PATH
    test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    . $HOME/.asdf/asdf.sh
    '';
    initExtraFirst = ''
      # Powerlevel10k instant prompt
      if [[ -r "$HOME/.cache/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "$HOME/.cache/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtraBeforeCompInit = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  programs.neovim = {
    enable = true;
    coc.enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      naumovs.color-highlight
      dbaeumer.vscode-eslint
      github.copilot
      eamodio.gitlens
      hashicorp.terraform
      jnoortheen.nix-ide
      esbenp.prettier-vscode
      prisma.prisma
      jock.svg
    ];
  };

  programs.fzf.enable = true;

  programs.bat.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host github.com
      AddKeysToAgent yes
      IgnoreUnknown UseKeychain
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
    '';
  };

  programs.direnv.enable = true;
}
