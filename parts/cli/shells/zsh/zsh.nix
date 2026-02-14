{ inputs, ... }:
{
  flake.nixosModules."zsh" =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        zsh
      ];
    };

  flake.homeModules."zsh" =
    { pkgs, config, ... }:
    let
      themePath = ".config/oh-my-posh/theme.json";
      homePath = config.xdg.dataHome;
    in
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;

        # history
        history = {
          path = "${homePath}/.zsh_history";
          size = 10000;
          save = 10000;
          append = true; # append don't override
          share = true; # share across terminals
          ignoreSpace = true; # put space before command, does not write to history (for sensitive things).
          # Save no duplicates
          saveNoDups = true;
          ignoreDups = true;
          ignoreAllDups = true;
          findNoDups = true;
        };

        oh-my-zsh.enable = false;

        plugins = [
          {
            name = "fzf-tab";
            src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
          }
        ];

        initContent =
          # init oh-my-posh
          ''
            OH_MY_POSH_THEME="${homePath}/${themePath}"
            eval "$(oh-my-posh init zsh --config $OH_MY_POSH_THEME)"
          ''
          # Completions
          + ''
            # ignore case (auto-complete)
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
            zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
            zstyle ':completion:*' menu no
            # cd completion preview
            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
          ''
          # Fuzzy find in history
          + ''
            eval "''$(fzf --zsh)"
          '';

        sessionVariables = {
          EDITOR = "code";
          TERMINAL = "kitty";
        };

        shellAliases = {
          glog = "[ -d ./.git ] && git log --all --decorate --oneline --graph --color=always | less -R";
          # Override commands
          cat = "bat";
          htop = "btop";
          ls = "ls --color";
        };
      };
    };
}
