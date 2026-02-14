{ inputs, ... }:
{
  flake.homeModules."yazi" =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ffmpeg # (for video thumbnails)
        p7zip # (for archive extraction and preview, requires non-standalone version)
        jq # (for JSON preview)
        poppler # (for PDF preview)
        fd # (for file searching)
        ripgrep # (for file content searching)
        fzf # (for quick file subtree navigation, >= 0.53.0)
        zoxide # (for historical directories navigation, requires fzf)
        resvg # (for SVG preview)
        imagemagick # (for Font, HEIC, and JPEG XL preview, >= 7.1.1)
        xclip # / wl-clipboard / xsel (for Linux clipboard support)
        ueberzugpp # or ueberzugpp in Nixpkgs
        ffmpegthumbnailer
        unar
      ];

      programs.yazi = {
        enable = true;
        settings = {
          opener = {
            directories = [
              {
                run = "code \"$@\"";
                block = true;
              }
            ];
          };

          mgr = {
            ratio = [
              1
              3
              3
            ];
            sort_by = "natural";
            sort_sensitive = true;
            sort_reverse = false;
            sort_dir_first = true;
            linemode = "none";
            show_hidden = true;
            show_symlink = true;
          };

          preview = {
            image_filter = "lanczos3";
            image_quality = 90;
            tab_size = 1;
            max_width = 720;
            max_height = 480;
            cache_dir = "";
            ueberzug_scale = 1;
            ueberzug_offset = [
              0
              0
              0
              0
            ];
          };

          tasks = {
            micro_workers = 5;
            macro_workers = 10;
            bizarre_retry = 5;
          };
        };
      };

      programs.bash = {
        shellAliases = {
          yazi = "yy";
        };
        initExtra = ''
          function yy() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXXX")" cwd
            yazi "$@" ---cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }
        '';
      };

      programs.zsh = {
        shellAliases = {
          yazi = "yy";
        };

        initContent = ''
          function yy() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXXXX")" cwd
            yazi "$@" ---cwd-file="$tmp"
            if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }
        '';
      };
    };
}
