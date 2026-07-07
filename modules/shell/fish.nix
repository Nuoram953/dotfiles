{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      nv = "nvim";
      cl = "clear";
      ll = "ls -lah";
    };
    functions = {
      __fzf_cd = ''
        set -l dir (
            fd --type=d --hidden --strip-cwd-prefix \
               --exclude .git \
               --exclude node_modules \
            | fzf
        )
        if test -n "$dir"
            cd "$dir"
            commandline -f repaint
        end
      '';
      __fzf_find_file = ''
        set -l result (
            fd --type=f --hidden --strip-cwd-prefix \
               --exclude .git \
               --exclude node_modules \
            | fzf
        )
        if test -n "$result"
            commandline -i -- $result
            commandline -f repaint
        end
      '';
      __fzf_reverse_isearch = ''
        history merge
        history | fzf --tiebreak=index | read -l result
        and commandline -- $result
        commandline -f repaint
      '';
    };
    interactiveShellInit = ''
      set -g fish_greeting '''
      set -Ux TERM xterm-256color
      set -gx EDITOR nvim
      set -gx PNPM_HOME "$HOME/.local/share/pnpm"
      fish_add_path "$PNPM_HOME"
      fish_add_path ~/.config/composer/vendor/bin
      fish_add_path ~/go/bin
      fish_add_path ~/.config/emacs/bin
      fish_add_path ~/.local/bin

      fish_add_path --prepend ~/.nix-profile/bin
      fish_add_path --prepend /nix/var/nix/profiles/default/bin

      set -gx mysqlclient_cflags "-I/usr/include/mysql"
      set -gx mysqlclient_ldflags "-L/usr/lib -lmysqlclient"
      bind ctrl-z '__fish_echo fg 2>/dev/null'
      if type -q fzf
          bind \cr __fzf_reverse_isearch
          bind \ct __fzf_find_file
          bind \ec __fzf_cd
          if type -q fd
              set -gx FZF_DEFAULT_COMMAND fd --hidden --strip-cwd-prefix --exclude .git
              set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
              set -gx FZF_CD_COMMAND fd --type=d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules
              set -gx FZF_ALT_C_COMMAND $FZF_CD_COMMAND
          end
          set -l fzf_opts \
              --style full --multi --height 40% \
              --color=fg:#839496 --color=bg:#002b36 --color=hl:#268bd2 \
              --color=fg+:#fdf6e3 --color=bg+:#073642 --color=hl+:#268bd2 \
              --color=info:#93a1a1 --color=prompt:#b58900 --color=pointer:#d33682 \
              --color=marker:#cb4b16 --color=spinner:#2aa198 --color=header:#586e75
          set -gx FZF_DEFAULT_OPTS (string join " " -- $fzf_opts)
      end
      # --- profile switch (config.fish) ---
      set -q PROFILE; or set -gx PROFILE $hostname
      switch $PROFILE
          case machine
              # personal.fish was empty - nothing to source
          case '*'
              set -Ux DOCKER_BUILDKIT 1
              set -x XDG_RUNTIME_DIR ~/.xdg_runtime
      end
    '';
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  home.packages = with pkgs; [ fzf fd nodejs ];
}
