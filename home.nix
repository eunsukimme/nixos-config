{ config, sources ? import ./nix/sources.nix, pkgs ? import sources.nixpkgs {}, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "evan.kim";
  home.homeDirectory = "/Users/evan.kim";
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
    asdf-vm

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
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = 1;
    # Example of using a variable within another path
    MY_CONFIG_DIR = "${config.home.homeDirectory}/.config/myprogram";
    alpha = "daangn/alpha";
    alpha_kr = "daangn/alpha/kr";
    # alpha_jp = "daangn/alpha/jp";
    # alpha_gb = "daangn/alpha/gb";
    # alpha_ca = "daangn/alpha/ca";
    prod = "daangn/prod";
    prod_kr = "daangn/prod/kr";
    # prod_jp = "daangn/prod/jp";
    # prod_gb = "daangn/prod/gb";
    # prod_ca = "daangn/prod/ca";
    data = "daangn/data";
    data_kr = "daangn/data/kr";
    # data_jp = "daangn/data/jp";
    # data_gb = "daangn/data/gb";
    # data_ca = "daangn/data/ca";
    ci_alpha = "daangn/ci-alpha";
    ci_prod = "daangn/ci-prod";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "evan-kim_karrot";
    userEmail = "evan.kim@daangn.com";
    aliases = {
      st = "status";
    };
    extraConfig = {
      core = {
        editor = "code -w";
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
      claude = "claude --dangerously-skip-permissions";
      # aws aliases
      aws-alpha = ''aws-vault exec "$alpha" -- aws'';
      aws-alpha-kr = ''aws-vault exec "$alpha_kr" -- aws'';
      # aws-alpha-jp = ''aws-vault exec "$alpha_jp" -- aws'';
      # aws-alpha-gb = ''aws-vault exec "$alpha_gb" -- aws'';
      # aws-alpha-ca = ''aws-vault exec "$alpha_ca" -- aws'';
      aws-prod = ''aws-vault exec "$prod" -- aws'';
      aws-prod-kr = ''aws-vault exec "$prod_kr" -- aws'';
      # aws-prod-jp = ''aws-vault exec "$prod_jp" -- aws'';
      # aws-prod-gb = ''aws-vault exec "$prod_gb" -- aws'';
      # aws-prod-ca = ''aws-vault exec "$prod_ca" -- aws'';
      aws-data = ''aws-vault exec "$data" -- aws'';
      aws-data-kr = ''aws-vault exec "$data_kr" -- aws'';
      # aws-data-jp = ''aws-vault exec "$data_jp" -- aws'';
      # aws-data-gb = ''aws-vault exec "$data_gb" -- aws'';
      # aws-data-ca = ''aws-vault exec "$data_ca" -- aws'';
      aws-ci-alpha = ''aws-vault exec "$ci_alpha" -- aws'';
      aws-ci-prod = ''aws-vault exec "$ci_prod" -- aws'';
    };
    initExtra = ''
    export NIXPKGS_ALLOW_UNFREE=1
    export PATH=/opt/homebrew/bin:$PATH
    test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"
    . $HOME/.asdf/asdf.sh
    . "$HOME/.nix-profile/share/asdf-vm/asdf.sh"

    # rust setup
    . "$HOME/.cargo/env"

    # bun setup
    export BUN_INSTALL="$HOME/.bun" 
    export PATH="$BUN_INSTALL/bin:$PATH"

    # uv setup
    source $HOME/.local/bin/env

    # intellij cli
    export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"

    # claude code bin
    export PATH="$PATH:$HOME/.local/bin/claude"
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
      jnoortheen.nix-ide
      esbenp.prettier-vscode
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

    Host github.com-emu
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519_github_emu
      IdentitiesOnly yes
      AddKeysToAgent yes
      UseKeychain yes
    '';
  };

  programs.direnv.enable = true;
}
