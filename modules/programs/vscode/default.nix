{
  inputs,
  self,
  ...
}: let
  moduleName = "vscode";
in {
  #! NOTE: this is not how you do nixos modules
  # Due to how I use vscode, trying out new extensions, in-app updatings, and generally
  # my development flow depending on quick nudges as I am not 'set' in how I use this
  #
  # software yet, I want to limit the amount of changes I would need for this file.
  # I have tried wrapping the module, I have tried using the command line tool to
  # configure, and I have exhausted my 'wanting' to configure this piece fully.
  #
  # As this is also how 'vscode' was designed to be, I conscribe it to a fault
  # in system philosophy, and may later try other code editing tools.
  flake.homeModules."${moduleName}" = {pkgs, ...}: let
  in {
    home.packages = with pkgs; [
      alejandra
      nixd
      nix-direnv
      docker-compose
      docker-compose-language-service
      devenv
    ];
    # xdg.configFile."VSCodium/User/keybindings.json".source =
    #   mkConfLink "/nix/flake/modules/programs/vscode/keybindings.json";
    # xdg.configFile."VSCodium/User/settings.json".source =
    #   mkConfLink "/nix/flake/modules/programs/vscode/settings.json";

    programs.vscodium = {
      enable = true;
      package = pkgs.vscodium-fhs;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          # Essentials
          mikestead.dotenv
          editorconfig.editorconfig

          # Interface Improvements
          eamodio.gitlens
          usernamehw.errorlens
          gruntfuggly.todo-tree
          aaron-bond.better-comments
          # linting
          esbenp.prettier-vscode

          # Nix
          jnoortheen.nix-ide
          arrterian.nix-env-selector

          # theming
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons

          # golang
          golang.go

          ms-azuretools.vscode-docker
        ];

        keybindings = [
          {
            "key" = "ctrl+n";
            "command" = "-workbench.action.chat.newChat";
            "when" = "chatIsEnabled && inChat && chatLocation == 'panel'";
          }
          {
            "key" = "ctrl+n";
            "command" = "-workbench.action.openChat";
            "when" = "chatIsEnabled && inChat && inChatEditor";
          }
          {
            "key" = "ctrl+n";
            "command" = "-chatEditor.action.undoHunk";
            "when" = "chatEdits.cursorInChangeRange && chatEdits.hasEditorModifications && editorFocus && !chatEdits.isCurrentlyBeingModified || chatEdits.cursorInChangeRange &&chatEdits.hasEditorModifications && notebookCellListFocused && !chatEdits.isCurrentlyBeingModified";
          }
          {
            "key" = "ctrl+n";
            "command" = "-workbench.action.files.newUntitledFile";
          }
          {
            "key" = "ctrl+n";
            "command" = "explorer.newFile";
          }
        ];

        userSettings = let
          nixFormatter = "${pkgs.alejandra}/bin/alejandra";
          nixLanguageServer = "${pkgs.nixd}/bin/nixd";
        in {
          "workbench.editor.closeOnFileDelete" = true;
          "explorer.autoReveal" = true;
          "editor.wordWrap" = "on";
          "editor.minimap.enabled" = false;
          "editor.stickyScroll.enabled" = true;
          "editor.renderWhitespace" = "trailing";
          # git
          "git.mergeEditor" = true;
          "git.autofetch" = true;
          # formatting on save
          "files.autoSave" = "off";
          "editor.formatOnSave" = true;
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          # bracket color pairs
          "editor.bracketPairColorization.enabled" = true;
          "editor.matchBrackets" = "near";
          "editor.guides.bracketPairs" = true;
          "window.title" = "$${dirty}$${activeEditorShort}$${separator}$${rootNameShort}";
          "window.menuBarVisibility" = "toggle"; # press alt to toggl
          "window.commandCenter" = false;
          "window.titleBarStyle" = "native";
          "workbench.layoutControl.enabled" = false;

          # disable telemetry
          "telemetry.enableCrashReporter" = false;
          "telemetry.enableTelemetry" = false;
          "telemetry.telemetryLevel" = "off";
          "telemetry.feedback.enabled" = false;
          "extensions.autoCheckUpdates" = false;
          "extensions.autoUpdate" = false;

          "nix.enableLanguageServer" = true;
          "nix.formatterPath" = nixFormatter;
          "nix.serverPath" = nixLanguageServer;
          "nix.serverSettings"."nixd" = {
            "formatting"."command" = [nixFormatter];
            "options" = let
              flake = "(builtins.getFlake \"${self}\")";
              host = "laptop";
              myOptions = "${flake}.nixosConfigurations.${host}.options";
            in {
              # nixpgs.expr = "import ${inputs.nixpkgs} { }";
              nixos.expr = myOptions;
              # home-manager.expr = myOptions + ".home-manager.users.type.getSubOptions []";
              home-manager.expr = "${flake}.homeConfigurations.${host}.options";
              # flake-parts.expr = "${flake}.debug.options";
            };
          };

          "workbench.iconTheme" = "catppuccin-mocha";
          "workbench.colorTheme" = "Catppuccin Mocha";

          # languages
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          "[go]" = {
            "editor.defaultFormatter" = "golang.go";
          };
        };
      };
    };

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
