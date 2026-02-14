{ ... }:
{

  flake.homeModules."newsboat" =
    { ... }:
    {

      programs.newsboat =
        let
          mkCategory =
            {
              name,
              entries ? [ ],
              filter ? null,
            }:
            let
              categoryEntry =
                if filter == null || filter == "" then
                  ''"query:├─ ${name}:(tags # \"${name}\")"''
                else
                  ''"query:├─ ${name}:(tags # \"${name}\") and ${filter}"'';

              newEntries = map (
                entry:
                entry
                // {
                  tags = [ "${name}" ] ++ (entry.tags or [ ]);
                }
              ) entries;
            in
            [ { url = categoryEntry; } ] ++ newEntries;
        in
        {
          enable = true;
          autoReload = true;
          reloadTime = 10;
          urls = [
          ]
          ++ mkCategory {
            name = "Reddit-top";
            filter = ''(age < 31) and (unread = \"yes\")'';
            entries = [
              {
                url = "https://www.reddit.com/r/programming/top/.rss";
                title = "Programming (top)";
              }
              {
                url = "https://www.reddit.com/r/unixporn/top/.rss";
                title = "Unixporn (top)";
                tags = [ "favorites" ];
              }
            ];
          };

          extraConfig = ''
            feedlist-format "%?T?│  ├── %5u %t &%t ?"
            articlelist-format "%?T?(%5T)? %f [%D]: %t"
          '';

          # {
          #   url = ''"query:├─ Reddit (top):(tags # \"reddit-top\") and (age < 4) and (unread = \"yes\")"'';
          # }
          # {
          #   url = "https://www.reddit.com/r/unixporn/top/.rss";
          #   tags = [ "reddit-top" ];
          # }
          # {
          #   url = "https://www.reddit.com/r/programming/top/.rss";
          #   tags = [ "reddit-top" ];
          # }
          # extraConfig = ''
          #   # ---------------------------------------
          #   # CYBRboat    newsboat theme (part of cybrland)
          #   # Project:    https://github.com/scherrer-txt/cybrland
          #   # Author:     scherrer-txt   |   License:     GPL-3
          #   # Source:     ~/.newsboat/config
          #   # ---------------------------------------

          #   # Base colors
          #   color background red default
          #   color article red default
          #   color listnormal white default
          #   color listfocus red black standout bold
          #   color listnormal_unread red default
          #   color listfocus_unread red black standout bold
          #   color title red default bold
          #   color info black red
          #   color hint-key black red bold
          #   color hint-keys-delimiter black red
          #   color hint-separator black red
          #   color hint-description black red

          #   # List Style
          #   feedlist-format "%?T?│  ├── %5u %t &%t ?"

          #   # # EMPTY
          #   highlight feedlist ".(0/0).*)" color15 default bold
          #   highlight feedlist ".\\(0/[1-9]+\\).*" white black
          # '';
        };
    };
}
