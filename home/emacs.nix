{ pkgs, ... }:
{
  programs.emacs = {
    enable = false;
    package = pkgs.emacs29;
    extraPackages = epkgs: [
      epkgs.magit
      epkgs.vterm
      epkgs.nix-mode
      epkgs.rust-mode
      epkgs.which-key
      epkgs.company
      epkgs.projectile
      epkgs.ripgrep
      epkgs.blacken
      epkgs.direnv
      epkgs.rustic
      epkgs.nord-theme
    ];
    # extraConfig = ''
    #   (blink-cursor-mode 0)
    #   (setq inhibit-splash-screen t)
    #   (setq inhibit-startup-message t)
    #   (dolist (m '(tooltip-mode tool-bar-mode scroll-bar-mode menu-bar-mode))
    #     (when (fboundp m) (funcall m -1)))
    #   (show-paren-mode 1)
    #   (prefer-coding-system 'utf-8)
    #   (fset 'yes-or-no-p 'y-or-n-p)
    #   (set-language-environment "UTF-8")
    #   (set-buffer-file-coding-system 'utf-8)
    #   (set-default 'truncate-lines nil)
    #   (setq mouse-wheel-scroll-amount '(1 ((shift) . 5)))
    #   (setq mouse-wheel-progressive-speed nil)
    #   (setq mouse-wheel-follow-mouse t)
    #   (add-hook 'before-save-hook 'delete-trailing-whitespace)
    #   (global-visual-line-mode t)
    #   (set-fringe-mode 10)

    #   ;; Enable nicer window moving
    #   (when (fboundp 'windmove-default-keybindings)
    #     (windmove-default-keybindings))

    #   ;; Disable visual bell
    #   (setq visible-bell nil)
    #   (setq ring-bell-function 'ignore)

    #   (setq indent-tabs-mode nil)
    #   (setq-default tab-width 4)

    #   (set-face-attribute 'default nil :family "JetBrains Mono" :weight "semibold" :height 140)
    #   (set-face-attribute 'fixed-pitch nil :family "JetBrains Mono" :weight "semibold" :height 140)
    #   ;; (set-face-attribute 'variable-pitch nil :family "Cantarell" :height 140)
    #   (set-face-attribute 'default (selected-frame) :height 140)

    #   (load-theme 'nord t)
    # '';
  };
  programs.doom-emacs = rec {
    enable = false;
    doomPrivateDir = ./doom.d;
    # Only init/packages so we only rebuild when those change.
    # https://github.com/znewman01/dotfiles/blob/be9f3a24c517a4ff345f213bf1cf7633713c9278/emacs/default.nix#L12-L34
    doomPackageDir =
      let
        filteredPath = builtins.path {
          path = doomPrivateDir;
          name = "doom-private-dir-filtered";
          filter = path: type:
            builtins.elem (baseNameOf path) [ "init.el" "packages.el" ];
        };
      in
      pkgs.linkFarm "doom-packages-dir" [
        {
          name = "init.el";
          path = "${filteredPath}/init.el";
        }
        {
          name = "packages.el";
          path = "${filteredPath}/packages.el";
        }
        {
          name = "config.el";
          path = pkgs.emptyFile;
        }
      ];
  };
}
